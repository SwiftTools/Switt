class DisallowWhitespacesTokenParserFactory: CustomTokenParserFactory {
    private let productionRule: ProductionRule
    
    init(productionRule: ProductionRule) {
        self.productionRule = productionRule
    }
    
    var involvedTerminals: [String] {
        return GrammarRulesMath.allTerminals(productionRule)
    }
    
    func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser {
        if let parserRule = parserRuleConverter.convertToParserRule(productionRule: productionRule) {
            return DisallowWhitespacesTokenParser(parserRule: parserRule, tokenParserFactory: tokenParserFactory)
        } else {
            // TODO: handle error
            return AlwaysFailTokenParser()
        }
    }
}