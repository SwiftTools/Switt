protocol TokenInputStream {
    // Get current token
    func token() -> Token?
    
    // Get token, relative to current position
    // 0: Current token
    // 1: Next token
    // -1: Previous token
    func tokenAt(index: Int) -> Token?
    
    var position: StreamPosition { get }
    
    func moveNext()
}

extension TokenInputStream {
    // Last token in stream
    func token() -> Token? {
        return tokenAt(0)
    }
    
    func moveToToken(matchFunction: Token -> Bool) {
        while let token = token() {
            if matchFunction(token) {
                break
            }
            moveNext()
        }
    }
    
    func tokenAt(index: Int, position: StreamPosition) -> Token? {
        let savedPosition = self.position
        position.restore()
        let token = self.tokenAt(index)
        savedPosition.restore()
        return token
    }
}