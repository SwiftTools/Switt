private extension ProductionRule {
    var canBeSimplified: Bool {
        switch self {
        case .CustomParser, .Eof:
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
        case .Empty, .CustomParser, .Eof:
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
    static func convertToLexerRule(rule: ProductionRule) -> LexerRule? {
        if let rule = simplifyRule(rule) {
            switch rule {
            case .Char(let ranges, let invert):
                return LexerRule.Char(ranges: ranges, invert: invert)
            case .Sequence(let productionRules):
                return LexerRule.Sequence(rules: productionRules.flatMap(convertToLexerRule))
            case .Alternatives(let productionRules):
                if (productionRules.contains { RuleMath.isEmpty($0) }) {
                    return nil
                } else {
                    return LexerRule.Alternatives(rules: productionRules.flatMap(convertToLexerRule))
                }
            case .RuleReference(let identifier):
                return LexerRule.RuleReference(identifier: identifier)
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
            case .CustomParser:
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
    
    static func simplifyRule(rule: ProductionRule) -> ProductionRule? {
        if rule.isSimplified {
            return rule
        } else if rule.canBeSimplified {
            let transformer = RepeatingProductionRuleTransformer(
                transformer: CompoundProductionRuleTransformer(
                    transformers: [
                        StripRepetitionProductionRuleTransformer(),
                        StripOptionalsProductionRuleTransformer(),
                        MergeCollectionsProductionRuleTransformer(),
                        StripEmptyProductionRuleTransformer(),
                        UnrollSequenceProductionRuleTransformer()
                    ]
                ),
                stopCondition: { rule in rule.isSimplified }
            )
            
            let rule = transformer.transform(rule)
            
            if rule.isSimplified {
                return rule
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}