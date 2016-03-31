// a b* c -> a c | a b+ c
class StripRepetitionProductionRuleTransformer: ProductionRuleTransformer {
    func transform(productionRule: ProductionRule) -> ProductionRule {
        switch productionRule {
        case .Sequence(let rules):
            return RuleCollectionMath.stripMultiples(rules.map(transform))
            
        // Recursion
        case .Alternatives(let rules):
            return RuleCollectionMath.makeAlternatives(rules: rules.map(transform))
        case .Optional(let rule):
            return .Optional(rule: transform(rule))
        case .Multiple(let atLeast, let rule):
            return .Multiple(atLeast: atLeast, rule: transform(rule))
        case .Lazy(let startRule, let rule, let stopRule):
            return .Lazy(
                startRule: transform(startRule),
                rule: transform(rule),
                stopRule: transform(stopRule)
            )
            
        case .CustomParser,
             .CustomTokenizer,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return productionRule
        }
    }
}