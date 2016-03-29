class BinaryOperatorTokenParserFactory: CustomTokenParserFactory {
    private let operatorRule: ProductionRule
    
    init(operatorRule: ProductionRule) {
        self.operatorRule = operatorRule
    }
    
    var involvedTerminals: [String] {
        return GrammarRulesMath.allTerminals(operatorRule)
    }
    
    func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser {
        if let parserRule = parserRuleConverter.convertToParserRule(productionRule: operatorRule) {
            return BinaryOperatorTokenParser(operatorRule: parserRule, tokenParserFactory: tokenParserFactory)
        } else {
            // TODO: handle error
            return AlwaysFailTokenParser()
        }
    }
}