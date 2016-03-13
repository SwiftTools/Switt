struct Grammar {
    typealias ContextCheckFunction = RuleName -> RuleContext
    
    var rules: GrammarRules
    var delimiter: ProductionRule
    var contextCheckFunction: ContextCheckFunction
}

struct GrammarRules {
    var rules: [RuleName: ProductionRule] = [:]
    var fragments: [RuleName: ProductionRule] = [:]
}