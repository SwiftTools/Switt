class TerminalTokenParser: TokenParser {
    private let terminal: String
    
    init(terminal: String) {
        self.terminal = terminal
    }
    
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        if let token = inputStream.getToken() where token.string == terminal {
            inputStream.moveNext()
            return SyntaxTree.leaf(token)
        } else {
            return SyntaxTree.fail()
        }
    }
}