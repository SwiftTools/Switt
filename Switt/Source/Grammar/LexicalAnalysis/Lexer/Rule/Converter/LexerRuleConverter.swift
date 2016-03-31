protocol LexerRuleConverter {
    func convertToLexerRule(rule: ProductionRule) -> LexerRule?
}