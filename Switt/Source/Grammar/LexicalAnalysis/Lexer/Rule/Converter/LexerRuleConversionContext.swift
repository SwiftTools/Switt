struct LexerRuleConversionContextStackElement {
    var prefix: LexerRulesPrefix
    var postfix: ProductionRulesPostfix
}

struct LexerRuleConversionContext {
    var stack: [LexerRuleConversionContextStackElement]
    
    static var empty: LexerRuleConversionContext {
        return LexerRuleConversionContext(
            stack: []
        )
    }
}