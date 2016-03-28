class ParserImpl: Parser {
    private let parserRules: ParserRules
    private let firstRule: RuleName
    
    init(parserRules: ParserRules, firstRule: RuleName) {
        self.parserRules = parserRules
        self.firstRule = firstRule
    }
    
    func parse(tokenInputStream: TokenInputStream) -> SyntaxTree? {
        let tokenParserFactory: TokenParserFactory = TokenParserFactoryImpl(
            parserRules: parserRules
        )
        
        let ruleWithEof = ParserRule.Sequence(
            rules: [
                ParserRule.RuleReference(identifier: RuleIdentifier.Named(firstRule)),
                ParserRule.Eof
            ]
        )
        
        if let tree = tokenParserFactory.tokenParser(ruleWithEof).parse(tokenInputStream)?.first {
            return tree
        } else {
            return nil
        }
    }
}