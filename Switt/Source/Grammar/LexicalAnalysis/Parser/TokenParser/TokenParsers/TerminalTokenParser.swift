class TerminalTokenParser: TokenParser {
    private let terminal: String
    
    init(terminal: String) {
        self.terminal = terminal
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let stream = inputStream.defaultChannel()
        
        if let token = stream.token() where token.string == terminal {
            stream.moveNext()
            return SyntaxTree.leaf(token)
        } else {
            return SyntaxTree.fail()
        }
    }
}