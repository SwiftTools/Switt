class ProductionRuleScannerErrorStream {
    private func positionDescription(position: CharacterStreamPosition) -> String {
        return "line: \(position.line), column: \(position.column)"
    }
    
    func canNotFindRule(ruleName: RuleName, position: CharacterStreamPosition) {
        print("Can not find rule: \(ruleName.debugDescription) \(positionDescription(position))")
    }
    
    func parserRuleInsideLexerRule(ruleName: RuleName, position: CharacterStreamPosition) {
        print("Found parser rule inside lexer rule: \(ruleName.debugDescription) \(positionDescription(position))")
    }
}