class TokenInputOutputStream: TokenInputStream, TokenOutputStream {
    private var index: Int = 0
    private var tokens: [Token] = []
    
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
        return tokens.at(index)
    }
    
    func moveNext() {
        index += 1
    }
    
    func putToken(token: Token) {
        tokens.append(token)
    }
    
    func finish() {
    }
}