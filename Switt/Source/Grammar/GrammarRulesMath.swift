class GrammarRulesMath {
    
    // rule
    
    static func rule(string: String) -> ProductionRule {
        return ProductionRule.StringRule(string)
    }
    
    static func rule(rule: ProductionRule) -> ProductionRule {
        return rule
    }
    
    static func rule(ruleName: RuleName) -> ProductionRule {
        return ProductionRule.Reference(ruleName)
    }
    
    // optional
    
    static func optional(string: String) -> ProductionRule {
        return ProductionRule.Optional(rule(string))
    }
    
    static func optional(lexeme: ProductionRule) -> ProductionRule {
        return ProductionRule.Optional(lexeme)
    }
    
    static func optional(lexemeType: RuleName) -> ProductionRule {
        return ProductionRule.Optional(rule(lexemeType))
    }
    
    // compound
    
    static func compound(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Compound(rules)
        } else if let first = rules.first {
            return first
        } else {
            return ProductionRule.Empty
        }
    }
    
    // any
    
    static func any(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Or(rules)
        } else if let first = rules.first {
            return first
        } else {
            return ProductionRule.Empty
        }
    }
    
    // zeroOrMore
    
    static func zeroOrMore(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Multiple(0, compound(rules))
        } else if let first = rules.first {
            return ProductionRule.Multiple(0, first)
        } else {
            return ProductionRule.Empty
        }
    }
    
    // oneOrMore
    
    static func oneOrMore(rules: [ProductionRule]) -> ProductionRule {
        if rules.count > 1 {
            return ProductionRule.Multiple(1, ProductionRule.Compound(rules))
        } else if let first = rules.first {
            return ProductionRule.Multiple(1, first)
        } else {
            return ProductionRule.Empty
        }
    }
}