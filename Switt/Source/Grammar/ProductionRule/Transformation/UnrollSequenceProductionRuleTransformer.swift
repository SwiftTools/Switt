// a (b | c) -> a b | a c
class UnrollSequenceProductionRuleTransformer: ProductionRuleTransformer {
    func transform(productionRule: ProductionRule) -> ProductionRule {
        switch productionRule {
            
        // Can unroll sequence
        case .Sequence(let rules):
            return RuleCollectionMath.unrollSequence(rules.map(transform))
            
        // Recursion
        case .Alternatives(let rules):
            return RuleCollectionMath.makeAlternatives(rules: rules.map(transform))
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