class NamedTerminalTokenParser: TokenParser {
    private let ruleName: RuleName
    
    init(ruleName: RuleName) {
        self.ruleName = ruleName
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let stream = inputStream.defaultChannel()
        
        if let token = stream.token() where token.ruleIdentifier == .Named(ruleName) {
            stream.moveNext()
            return SyntaxTree.leaf(token)
        } else {
            return SyntaxTree.fail()
        }
    }
}