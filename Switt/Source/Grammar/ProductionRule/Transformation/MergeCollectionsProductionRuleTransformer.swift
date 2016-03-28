class MergeCollectionsProductionRuleTransformer: ProductionRuleTransformer {
    // (a|b)|(c|d) -> a|b|c|d
    // (a b) (c d) -> a b c d
    func transform(productionRule: ProductionRule) -> ProductionRule {
        switch productionRule {
            
        // Can merge sequences
        case .Sequence(let rules):
            let rules = rules.map(transform).map { RuleMath.convertToSequence($0) }.joinWithSeparator([]).map { $0 }
            return RuleCollectionMath.makeSequence(rules: rules)
            
        // Can merge alternatives
        case .Alternatives(let rules):
            let rules = rules.map(transform).map { RuleMath.convertToAlternatives($0) }.joinWithSeparator([]).map { $0 }
            return RuleCollectionMath.makeAlternatives(rules: rules)
            
        // Recursion
        case .Optional(let rule):
            return .Optional(rule: transform(rule))
        case .Multiple(let atLeast, let rule):
            return .Multiple(atLeast: atLeast, rule: transform(rule))
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            return .Lazy(
                rule: transform(rule),
                stopRule: transform(stopRule),
                stopRuleIsRequired: stopRuleIsRequired
            )
            
        case .Check,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return productionRule
        }
    }
}