class TerminalTokenParser: TokenParser {
    private let terminal: String
    
    init(terminal: String) {
        self.terminal = terminal
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        inputStream.moveToToken { $0.channel ~= .Default }
        
        if let token = inputStream.token() where token.string == terminal {
            inputStream.moveNext()
            return SyntaxTree.leaf(token)
        } else {
            position.restore()
            return SyntaxTree.fail()
        }
    }
}