class RuleReferenceTokenParser: TokenParser {
    private let ruleIdentifier: RuleIdentifier
    private let tokenParserFactory: TokenParserFactory
    
    init(ruleIdentifier: RuleIdentifier, tokenParserFactory: TokenParserFactory) {
        self.ruleIdentifier = ruleIdentifier
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        if let referencedTokenParser = tokenParserFactory.tokenParser(ruleIdentifier) {
            let result = referencedTokenParser.tokenParser.parse(inputStream)
            
            switch referencedTokenParser {
            case .FragmentParser:
                return result
            case .RuleParser(_, let ruleName):
                return result.flatMap { children in SyntaxTree.tree(ruleName, children) }
            }
        } else {
            abort() // TODO
            return nil
        }
    }
}