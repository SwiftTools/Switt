class ParserRuleCustomTokenParserFactoryImpl: ParserRuleCustomTokenParserFactory {
    private let customTokenParserFactory: CustomTokenParserFactory
    private let parserRuleConverter: ParserRuleConverter
    
    init(customTokenParserFactory: CustomTokenParserFactory, parserRuleConverter: ParserRuleConverter) {
        self.customTokenParserFactory = customTokenParserFactory
        self.parserRuleConverter = parserRuleConverter
    }
    
    func tokenParser(tokenParserFactory: TokenParserFactory) -> TokenParser {
        return customTokenParserFactory.tokenParser(tokenParserFactory, parserRuleConverter: parserRuleConverter)
    }
}