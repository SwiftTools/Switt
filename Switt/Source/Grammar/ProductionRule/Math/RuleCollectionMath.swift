class RuleCollectionMath {
    // a b? c -> a b c | a c
    // First: with optional rule
    // Second: without optional rule
    static func splitOptional(rulesBefore rulesBefore: [ProductionRule], optional: ProductionRule, rulesAfter: [ProductionRule]) -> ProductionRule {
        
        return splitAlternatives(
            rulesBefore: rulesBefore,
            alternatives: [[optional], []],
            rulesAfter: rulesAfter
        )
    }
    
    static func splitAlternatives(rulesBefore rulesBefore: [ProductionRule], alternatives: [[ProductionRule]], rulesAfter: [ProductionRule]) -> ProductionRule {
        
        let mergedAlternatives = alternatives.map { makeSequence(rules: rulesBefore + $0 + rulesAfter) }
        
        return ProductionRule.Alternatives(
            rules: mergedAlternatives
        )
    }
    
    // a b? c -> a c | a b c
    static func stripOptionals(rules: [ProductionRule]) -> ProductionRule {
        var newRules: [ProductionRule] = []
        
        for (id, rule) in rules.enumerate() {
            switch rule {
            case .Optional(let rule):
                let rule = splitOptional(
                    rulesBefore: newRules,
                    optional: rule,
                    rulesAfter: rules.suffixFrom(id).dropFirst().map { $0 }
                )
                return rule
            case .CustomParser,
                 .CustomTokenizer,
                 .Char,
                 .RuleReference,
                 .Sequence,
                 .Alternatives,
                 .Terminal,
                 .Lazy,
                 .Multiple,
                 .Empty,
                 .Eof:
                newRules.append(rule)
            }
        }
        
        return makeSequence(rules: newRules)
    }
    
    // a b* c -> a c | a b+ c
    static func stripMultiples(rules: [ProductionRule]) -> ProductionRule {
        var newRules: [ProductionRule] = []
        
        for (id, rule) in rules.enumerate() {
            switch rule {
            case .Multiple(let atLeast, let rule):
                if atLeast == 0 {
                    let rule = splitOptional(
                        rulesBefore: newRules,
                        optional: ProductionRule.Multiple(atLeast: 1, rule: rule),
                        rulesAfter: rules.suffixFrom(id).dropFirst().map { $0 }
                    )
                    return rule
                } else if atLeast == 1 {
                    let rule = ProductionRule.Multiple(atLeast: 1, rule: rule) // 1 or more
                    newRules.append(rule)
                } else {
                    let required = (0..<(atLeast - 1)).map { _ in rule }
                    let rule = makeSequence(
                        rules: required + [ProductionRule.Multiple(atLeast: 1, rule: rule)]
                    )
                    newRules.append(rule)
                }
            case .CustomParser,
                 .CustomTokenizer,
                 .Char,
                 .RuleReference,
                 .Sequence,
                 .Alternatives,
                 .Optional,
                 .Terminal,
                 .Lazy,
                 .Empty,
                 .Eof:
                newRules.append(rule)
            }
        }
        
        return makeSequence(rules: newRules)
    }
    
    static func unrollSequence(rules: [ProductionRule]) -> ProductionRule {
        var newRules: [ProductionRule] = []
        
        for (id, rule) in rules.enumerate() {
            switch rule {
            case .Alternatives(let innerRules):
                let rule = splitAlternatives(
                    rulesBefore: newRules,
                    alternatives: innerRules.map { [$0] },
                    rulesAfter: rules.suffixFrom(id).dropFirst().map { $0 }
                )
                return rule
                
            case .CustomParser,
                 .CustomTokenizer,
                 .Char,
                 .RuleReference,
                 .Sequence,
                 .Optional,
                 .Terminal,
                 .Lazy,
                 .Multiple,
                 .Empty,
                 .Eof:
                newRules.append(rule)
            }
        }
        
        return makeSequence(rules: newRules)
    }
    
    // (a b) -> (a b)
    // (a) -> a
    static func makeSequence(rules rules: [ProductionRule]) -> ProductionRule {
        if rules.count == 0 {
            return ProductionRule.Empty
        } else if rules.count == 1, let first = rules.first {
            return first
        } else {
            return ProductionRule.Sequence(rules: rules)
        }
    }
    
    // (a b) -> (a b)
    // (a) -> a
    static func makeAlternatives(rules rules: [ProductionRule]) -> ProductionRule {
        if rules.count == 0 {
            return ProductionRule.Empty
         } else if rules.count == 1, let first = rules.first {
            return first
        } else {
            return ProductionRule.Alternatives(rules: rules)
        }
    }
}