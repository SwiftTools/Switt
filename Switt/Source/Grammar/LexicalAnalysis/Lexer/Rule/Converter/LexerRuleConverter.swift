private extension ProductionRule {
    var sequence: [ProductionRule]? {
        switch self {
        case .Sequence(let rules):
            return rules
        default:
            return nil
        }
    }
    
    var alternatives: [ProductionRule]? {
        switch self {
        case .Alternatives(let rules):
            return rules
        default:
            return nil
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .Empty:
            return true
        default:
            return false
        }
    }
    
    var canBeSimplified: Bool {
        switch self {
        case .Check, .Eof:
            return false
        case .RuleReference, .Terminal, .Char:
            // Already simple
            return true
        case .Empty:
            // Can be transformed
            return true
        case .Multiple(_, let rule):
            return rule.canBeSimplified
        case .Optional(let rule):
            return rule.canBeSimplified
        case .Alternatives(let rules):
            return !rules.contains { !$0.canBeSimplified }
        case .Sequence(let rules):
            return !rules.contains { !$0.canBeSimplified }
        case .Lazy(let rule, let stopRule, _):
            return rule.canBeSimplified && stopRule.canBeSimplified
        }
    }
    
    var isSimplified: Bool {
        switch self {
            // Valid simple rules
        case .Char, .RuleReference, .Terminal:
            return true
            
            // Invalid rules
        case .Empty, .Check, .Eof:
            return false
            
            // Only "at least 1" rules are valid
        case .Multiple(let times, let rule):
            return times == 1 && rule.isSimplified
            
            // Optional is not simplified
        case .Optional:
            return false
            
            // All rules should be simplified
        case .Alternatives(let rules):
            return !rules.contains { !$0.isSimplified }
        case .Sequence(let rules):
            return !rules.contains { !$0.isSimplified }
        case .Lazy(let rule, let stopRule, _):
            return rule.isSimplified && stopRule.isSimplified
        }
    }
}

class LexerRuleConverter {
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
            case .Check,
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
            case .Check,
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
    
    // a b* c -> a c | a b+ c
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
                
            case .Check,
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
        if rules.count == 1 {
            return rules[0]
        } else {
            return ProductionRule.Sequence(rules: rules)
        }
    }
    
    // (a b) -> (a b)
    // (a) -> a
    static func makeAlternatives(rules rules: [ProductionRule]) -> ProductionRule {
        if rules.count == 1 {
            return rules[0]
        } else {
            return ProductionRule.Alternatives(rules: rules)
        }
    }
    
    // a b* c -> a c | a b+ c
    static func stripMultiples(rule: ProductionRule) -> ProductionRule {
        switch rule {
        case .Sequence(let rules):
            return stripMultiples(rules.map(stripMultiples))
            
            // Recursion
        case .Alternatives(let rules):
            return makeAlternatives(rules: rules.map(stripMultiples))
        case .Optional(let rule):
            return .Optional(rule: stripMultiples(rule))
        case .Multiple(let atLeast, let rule):
            return .Multiple(atLeast: atLeast, rule: stripMultiples(rule))
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            return .Lazy(
                rule: stripMultiples(rule),
                stopRule: stripMultiples(stopRule),
                stopRuleIsRequired: stopRuleIsRequired
            )
            
        case .Check,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty, 
             .Eof:
            return rule
        }
    }
    
    // a b? c -> a c | a b c
    static func stripOptionals(rule: ProductionRule) -> ProductionRule {
        switch rule {
            // Can strip optionals in sequence
        case .Sequence(let rules):
            return stripOptionals(rules.map(stripOptionals))
            
            // Recursion:
        case .Alternatives(let rules):
            return makeAlternatives(rules: rules.map(stripOptionals))
        case .Optional(let rule):
            return .Optional(rule: stripOptionals(rule))
        case .Multiple(let atLeast, let rule):
            return .Multiple(atLeast: atLeast, rule: stripOptionals(rule))
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            return .Lazy(
                rule: stripOptionals(rule),
                stopRule: stripOptionals(stopRule),
                stopRuleIsRequired: stopRuleIsRequired
            )
            
        case .Check,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return rule
        }
    }
    
    // (a|b)|(c|d) -> a|b|c|d
    // (a b) (c d) -> a b c d
    static func mergeCollections(rule: ProductionRule) -> ProductionRule {
        switch rule {
            
            // Can merge sequences
        case .Sequence(let rules):
            let rules = rules.map(mergeCollections)
            let sequences: [[ProductionRule]] = rules.flatMap { $0.sequence }
            if rules.count == sequences.count {
                let rules: [ProductionRule] = sequences.joinWithSeparator([]).map { $0 }
                return ProductionRule.Sequence(rules: rules)
            } else {
                ProductionRule.Sequence(rules: rules)
            }
            return rule
            
            // Can merge alternatives
        case .Alternatives(let rules):
            let rules = rules.map(mergeCollections)
            let alternatives: [[ProductionRule]] = rules.flatMap { $0.alternatives }
            if rules.count == alternatives.count {
                let rules: [ProductionRule] = alternatives.joinWithSeparator([]).map { $0 }
                return ProductionRule.Alternatives(rules: rules)
            } else {
                return ProductionRule.Alternatives(rules: rules)
            }
            
            // Recursion
        case .Optional(let rule):
            return .Optional(rule: mergeCollections(rule))
        case .Multiple(let atLeast, let rule):
            return .Multiple(atLeast: atLeast, rule: mergeCollections(rule))
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            return .Lazy(
                rule: mergeCollections(rule),
                stopRule: mergeCollections(stopRule),
                stopRuleIsRequired: stopRuleIsRequired
            )
            
            
        case .Check,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return rule
        }
    }
    
    // a <e> b -> a b
    // a | <e> | b -> <e>
    static func removeUnusedEmptys(rule: ProductionRule) -> ProductionRule {
        switch rule {
            
            // Can remove emptys from sequence
        case .Sequence(let rules):
            
            // Can remove emptys from alternatives
            return makeSequence(rules: rules.filter { !$0.isEmpty }.map(removeUnusedEmptys))
        case .Alternatives(let rules):
            if (rules.contains { $0.isEmpty }) {
                return ProductionRule.Empty
            } else {
                return makeAlternatives(rules: rules)
            }
            
            // Can remove empty optional
        case .Optional(let rule):
            if rule.isEmpty {
                return ProductionRule.Empty
            } else {
                return .Optional(rule: removeUnusedEmptys(rule))
            }
            
            // Can remove empty multiple
        case .Multiple(let atLeast, let rule):
            if rule.isEmpty {
                return ProductionRule.Empty
            } else {
                return .Multiple(atLeast: atLeast, rule: removeUnusedEmptys(rule))
            }
            
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            if rule.isEmpty {
                return ProductionRule.Empty
            } else if stopRule.isEmpty {
                return .Multiple(atLeast: 0, rule: removeUnusedEmptys(rule))
            } else {
                return .Lazy(
                    rule: removeUnusedEmptys(rule),
                    stopRule: removeUnusedEmptys(stopRule),
                    stopRuleIsRequired: stopRuleIsRequired
                )
            }
            
        case .Check,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return rule
        }
    }
    
    // a (b | c) -> a b | a c
    static func unrollSequence(rule: ProductionRule) -> ProductionRule {
        switch rule {
            
            // Can unroll sequence
        case .Sequence(let rules):
            return unrollSequence(rules.map(unrollSequence))
            
            // Recursion
        case .Alternatives(let rules):
            return makeAlternatives(rules: rules.map(unrollSequence))
        case .Optional(let rule):
            return .Optional(rule: unrollSequence(rule))
        case .Multiple(let atLeast, let rule):
            return .Multiple(atLeast: atLeast, rule: unrollSequence(rule))
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            return .Lazy(
                rule: unrollSequence(rule),
                stopRule: unrollSequence(stopRule),
                stopRuleIsRequired: stopRuleIsRequired
            )

        case .Check,
             .Char,
             .RuleReference,
             .Terminal,
             .Empty,
             .Eof:
            return rule
        }
    }
    
    static func simplifyRule(rule: ProductionRule) -> ProductionRule? {
        if rule.isSimplified {
            return rule
        } else if rule.canBeSimplified {
            let functions: [ProductionRule -> ProductionRule] = [
                stripMultiples,
                stripOptionals,
                mergeCollections,
                removeUnusedEmptys,
                unrollSequence
            ]
            
            var rule = rule
            
            while true {
                let ruleBefore = rule
                
                for function in functions {
                    rule = function(rule)
                }
                
                if rule.isSimplified {
                    return rule
                }
                
                if ruleBefore == rule {
                    // Can't simplify
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
    
    static func convertToLexerRule(rule: ProductionRule) -> LexerRule? {
        if let rule = simplifyRule(rule) {
            switch rule {
            case .Char(let ranges, let invert):
                return LexerRule.Char(ranges: ranges, invert: invert)
            case .Sequence(let productionRules):
                return LexerRule.Sequence(rules: productionRules.flatMap(convertToLexerRule))
            case .Alternatives(let productionRules):
                if (productionRules.contains { $0.isEmpty }) {
                    return nil
                } else {
                    return LexerRule.Alternatives(rules: productionRules.flatMap(convertToLexerRule))
                }
            case .RuleReference(let ruleName):
                return LexerRule.RuleReference(ruleName: ruleName)
            case .Terminal(let terminal):
                return LexerRule.Terminal(terminal: terminal)
                
            case .Multiple(let atLeast, let rule):
                if atLeast == 1, let lexerRule = convertToLexerRule(rule) {
                    return LexerRule.Repetition(rule: lexerRule)
                } else {
                    // Should be converted at simplification stage
                    return nil
                }
                
                // Should be converted at simplification stage
            case .Empty:
                return nil
            case .Eof:
                return nil
            case .Optional:
                return nil
            case .Check:
                return nil
            case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
                if let rule = convertToLexerRule(rule), let stopRule = convertToLexerRule(stopRule) {
                    return LexerRule.Lazy(rule: rule, stopRule: stopRule, stopRuleIsRequired: stopRuleIsRequired)
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
}