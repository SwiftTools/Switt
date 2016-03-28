class OptionalTokenParser: TokenParser {
    private let rule: ParserRule
    private let tokenParserFactory: TokenParserFactory
    
    init(rule: ParserRule, tokenParserFactory: TokenParserFactory) {
        self.rule = rule
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        let position = inputStream.position
        
        let parser = tokenParserFactory.tokenParser(rule)
        if let result = parser.parse(inputStream) {
            return result
        } else {
            position.restore()
            return SyntaxTree.success()
        }
    }
}