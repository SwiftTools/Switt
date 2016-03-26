class GrammarRulesMath {
    
    // rule
    
    static func rule(terminal: String) -> ProductionRule {
        return ProductionRule.Terminal(terminal: terminal)
    }
    
    static func rule(rule: ProductionRule) -> ProductionRule {
        return rule
    }
    
    static func rule(ruleName: RuleName) -> ProductionRule {
        return ProductionRule.RuleReference(ruleName: ruleName)
    }
    
    // optional
    
    static func optional(string: String) -> ProductionRule {
        return ProductionRule.Optional(rule: rule(string))
    }
    
    static func optional(lexeme: ProductionRule) -> ProductionRule {
        return ProductionRule.Optional(rule: lexeme)
    }
    
    static func optional(lexemeType: RuleName) -> ProductionRule {
        return ProductionRule.Optional(rule: rule(lexemeType))
    }
    
    // compound
    
    static func compound(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Sequence(rules: rules)
        } else if let first = rules.first {
            return first
        } else {
            return ProductionRule.Empty
        }
    }
    
    // any
    
    static func any(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Alternatives(rules: rules)
        } else if let first = rules.first {
            return first
        } else {
            return ProductionRule.Empty
        }
    }
    
    // zeroOrMore
    
    static func zeroOrMore(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Multiple(atLeast: 0, rule: compound(rules))
        } else if let first = rules.first {
            return ProductionRule.Multiple(atLeast: 0, rule: first)
        } else {
            return ProductionRule.Empty
        }
    }
    
    // oneOrMore
    
    static func oneOrMore(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Multiple(atLeast: 1, rule: ProductionRule.Sequence(rules: rules))
        } else if let first = rules.first {
            return ProductionRule.Multiple(atLeast: 1, rule: first)
        } else {
            return ProductionRule.Empty
        }
    }
    
    // misc
    
    static func allTerminals(rule: ProductionRule) -> [String] {
        switch rule {
        case .Alternatives(let rules):
            return rules.reduce([], combine: { (terminals, rule) in
                terminals + allTerminals(rule)
            })
        case .Sequence(let rules):
            return rules.reduce([], combine: { (terminals, rule) in
                terminals + allTerminals(rule)
            })
        case .Char, .Check, .Empty, .Eof, .RuleReference:
            return []
        case .Multiple(_, let rule):
            return allTerminals(rule)
        case .Optional(let rule):
            return allTerminals(rule)
        case .Terminal(let terminal):
            return [terminal]
        case .Lazy(let rule, let stopRule, _):
            return allTerminals(rule) + allTerminals(stopRule)
        }
    }
}