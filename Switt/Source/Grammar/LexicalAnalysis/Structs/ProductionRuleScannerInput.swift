
struct ProductionRuleScannerInput {
    var inputStream: CharacterInputStream
    var grammar: Grammar
    var ruleContext: RuleContext
    var rulesThatCanCauseRecursion: Set<RuleName>
    var tokens: [Token]
}