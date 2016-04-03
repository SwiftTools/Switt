class PostfixOperatorTokenParserFactory: CustomTokenParserFactory {
    private let operatorRule: ProductionRule
    private var parserRule: ParserRule?? = nil
    
    init(operatorRule: ProductionRule) {
        self.operatorRule = operatorRule
    }
    
    var involvedTerminals: [String] {
        return GrammarRulesMath.allTerminals(operatorRule)
    }
    
    func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser {
        // Quick fix of #8:
        if parserRule == nil {
            parserRule = parserRuleConverter.convertToParserRule(productionRule: operatorRule)
        }
        
        if let parserRule = (parserRule?.flatMap { $0 }) {
            return PostfixOperatorTokenParser(operatorRule: parserRule, tokenParserFactory: tokenParserFactory)
        } else {
            // TODO: handle error
            return AlwaysFailTokenParser()
        }
    }
}