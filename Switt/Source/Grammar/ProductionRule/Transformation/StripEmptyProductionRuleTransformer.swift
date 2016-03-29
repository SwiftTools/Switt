// a <e> b -> a b
class StripEmptyProductionRuleTransformer: ProductionRuleTransformer {
    func transform(productionRule: ProductionRule) -> ProductionRule {
        switch productionRule {
            
        // Can remove emptys from sequence
        case .Sequence(let rules):
            return RuleCollectionMath.makeSequence(rules: rules.filter { !RuleMath.isEmpty($0) }.map(transform))
        case .Alternatives(let rules):
            return RuleCollectionMath.makeAlternatives(rules: rules.map(transform))
            
        // Can remove empty optional
        case .Optional(let rule):
            if RuleMath.isEmpty(rule) {
                return ProductionRule.Empty
            } else {
                return .Optional(rule: transform(rule))
            }
            
        // Can remove empty multiple
        case .Multiple(let atLeast, let rule):
            if RuleMath.isEmpty(rule) {
                return ProductionRule.Empty
            } else {
                return .Multiple(atLeast: atLeast, rule: transform(rule))
            }
            
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            if RuleMath.isEmpty(rule) {
                return ProductionRule.Empty
            } else if RuleMath.isEmpty(stopRule) {
                return .Multiple(atLeast: 0, rule: transform(rule))
            } else {
                return .Lazy(
                    rule: transform(rule),
                    stopRule: transform(stopRule),
                    stopRuleIsRequired: stopRuleIsRequired
                )
            }
            
        case .CustomParser,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return productionRule
        }
    }
}