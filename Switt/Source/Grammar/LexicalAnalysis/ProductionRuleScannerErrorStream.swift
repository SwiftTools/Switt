class ProductionRuleScannerErrorStream {
    private func positionDescription(position: StreamPosition) -> String {
        return "line: \(position.line), column: \(position.column)"
    }
    
    func canNotFindRule(ruleName: RuleName, position: StreamPosition) {
        print("Can not find rule: \(ruleName.debugDescription) \(positionDescription(position))")
    }
    
    func parserRuleInsideLexerRule(ruleName: RuleName, position: StreamPosition) {
        print("Found parser rule inside lexer rule: \(ruleName.debugDescription) \(positionDescription(position))")
    }
}