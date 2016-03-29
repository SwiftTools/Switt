class FilteredTokenInputStream: TokenInputStream {
    private var currentIndex: Int = 0
    
    // Cache
    private var tokensAfterStart: [Token] = []
    private var tokensBeforeStart: [Token] = []
    
    private var sourceStreamStartPosition: StreamPosition
    private var sourceStreamNegativeIndex: Int
    
    private let filter: (Token) -> Bool
    private let sourceStream: TokenInputStream
    
    private var positionWasSetUp: Bool = false
    
    init(stream: TokenInputStream, filter: (Token) -> Bool) {
        self.filter = filter
        sourceStream = stream
        sourceStreamStartPosition = stream.position
        sourceStreamNegativeIndex = -1
    }
    
    convenience init(stream: TokenInputStream, channel: TokenChannel) {
        self.init(
            stream: stream,
            filter: { token in
                return token.channel == channel
            }
        )
    }
    
    var position: StreamPosition {
        return StreamPosition(
            restoreFunction: { [weak self,
                savedIndex = currentIndex,
                sourceStreamPosition = sourceStream.position,
                sourceStreamStartPosition = sourceStreamStartPosition
                ] in
                
                self?.currentIndex = savedIndex
                if savedIndex == 0 {
                    self?.positionWasSetUp = false
                    sourceStreamStartPosition.restore()
                } else {
                    sourceStreamPosition.restore()
                }
            },
            distanceToCurrent: { [weak self, savedIndex = currentIndex] in
                return (self?.currentIndex ?? 0) - savedIndex
            }
        )
    }
    
    func tokenAt(relativeIndex: Int) -> Token? {
        let tokenAtIndex: Token?
        
        let savedPosition = position
        let savedSourceStreamPosition = sourceStream.position
        
        setUpPosition()
        
        let index = currentIndex + relativeIndex
        
        if index >= 0 {
            if let existingToken = tokensAfterStart.at(index) {
                tokenAtIndex = existingToken
            } else {
                var tokensToGet = index - tokensAfterStart.count + 1
                
                assert(tokensToGet > 0)
                
                while let token = sourceStream.token() where tokensToGet > 0 {
                    sourceStream.moveNext()
                    
                    if filter(token) {
                        tokensAfterStart.append(token)
                        tokensToGet -= 1
                    }
                }
                
                let successfullyGotLastToken = tokensToGet == 0
                
                tokenAtIndex = successfullyGotLastToken ? tokensAfterStart.last : nil
            }
        } else {
            let negativeIndex = -(1 + index) // index = -1, negativeIndex = 0
            if let existingToken = tokensBeforeStart.at(negativeIndex) {
                tokenAtIndex = existingToken
            } else {
                var tokensToGet = negativeIndex - tokensBeforeStart.count + 1
                
                assert(tokensToGet > 0)
                
                sourceStreamStartPosition.restore()
                
                while let token = sourceStream.tokenAt(sourceStreamNegativeIndex) where tokensToGet > 0 {
                    if filter(token) {
                        tokensBeforeStart.append(token)
                        tokensToGet -= 1
                    }
                    sourceStreamNegativeIndex -= 1
                }
                
                let successfullyGotLastToken = tokensToGet == 0
                
                tokenAtIndex = successfullyGotLastToken ? tokensBeforeStart.last : nil
            }
        }
        
        // tokenAt shouldn't modify position
        
        savedPosition.restore()
        savedSourceStreamPosition.restore()
        
        return tokenAtIndex
    }
    
    func moveNext() {
        setUpPosition()
        sourceStream.moveNext()
        
        while let token = sourceStream.token() where !filter(token) {
            sourceStream.moveNext()
        }
        if currentIndex < tokensAfterStart.count {
            currentIndex += 1
        }
    }
    
    func setUpPosition() {
        if !positionWasSetUp {
            positionWasSetUp = true
            
            while let token = sourceStream.token() where !filter(token) {
                sourceStream.moveNext()
            }
        }
    }
}