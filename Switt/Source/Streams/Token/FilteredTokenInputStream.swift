class FilteredTokenInputStream: TokenInputStream {
    private var index: Int = 0
    private var tokens: [Token] = []
    private let filter: (Token) -> Bool
    private let stream: TokenInputStream
    
    init(stream: TokenInputStream, filter: (Token) -> Bool) {
        self.filter = filter
        self.stream = stream
    }
    
    convenience init(stream: TokenInputStream, channel: LexerChannel) {
        self.init(
            stream: stream,
            filter: { token in
                return token.channel == channel
            }
        )
    }
    
    var position: StreamPosition {
        return StreamPosition(
            restoreFunction: { [weak self, savedIndex = index] in
                self?.index = savedIndex
            },
            distanceToCurrent: { [weak self, savedIndex = index] in
                return (self?.index ?? 0) - savedIndex
            }
        )
    }
    
    func getToken() -> Token? {
        if let existingToken = tokens.at(Int(index)) {
            return existingToken
        } else if index == tokens.endIndex {
            while let token = stream.getToken() {
                stream.moveNext()
                
                if filter(token) {
                    tokens.append(token)
                    return token
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    func moveNext() {
        if index <= tokens.endIndex {
            index += 1
        }
    }
}