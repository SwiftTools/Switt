class NamedTerminalTokenParser: TokenParser {
    private let ruleName: RuleName
    
    init(ruleName: RuleName) {
        self.ruleName = ruleName
    }
    
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        if let token = inputStream.getToken() where token.ruleIdentifier == .Named(ruleName) {
            inputStream.moveNext()
            return SyntaxTree.leaf(token)
        } else {
            return SyntaxTree.fail()
        }
    }
}