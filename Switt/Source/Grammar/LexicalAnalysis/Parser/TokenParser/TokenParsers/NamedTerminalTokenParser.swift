class NamedTerminalTokenParser: TokenParser {
    private let ruleName: RuleName
    
    init(ruleName: RuleName) {
        self.ruleName = ruleName
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        inputStream.moveToToken { $0.channel ~= .Default }
        
        if let token = inputStream.token() where token.ruleIdentifier == .Named(ruleName) {
            inputStream.moveNext()
            return SyntaxTree.leaf(token)
        } else {
            position.restore()
            return SyntaxTree.fail()
        }
    }
}