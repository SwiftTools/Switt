class DisallowHiddenTokensTokenParserFactory: CustomTokenParserFactory {
    private let productionRule: ProductionRule
    private var parserRule: ParserRule?? = nil
    
    init(productionRule: ProductionRule) {
        self.productionRule = productionRule
    }
    
    var involvedTerminals: [String] {
        return GrammarRulesMath.allTerminals(productionRule)
    }
    
    func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser {
        // Quick fix of #8:
        if parserRule == nil {
            parserRule = parserRuleConverter.convertToParserRule(productionRule: productionRule)
        }
        
        if let parserRule = (parserRule?.flatMap { $0 }) {
            return DisallowHiddenTokensTokenParser(parserRule: parserRule, tokenParserFactory: tokenParserFactory)
        } else {
            // TODO: handle error
            return AlwaysFailTokenParser()
        }
    }
}