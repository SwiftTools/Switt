protocol GrammarRulesBuilder: class {
}

extension GrammarRulesBuilder {
    // compound
    
    func compound(rules: [ProductionRule]) -> ProductionRule {
        return ProductionRule.Sequence(rules: rules)
    }
    
    func compound(rules: ProductionRule...) -> ProductionRule {
        let rules: [ProductionRule] = rules
        return compound(rules)
    }
    
    func compound(names: RuleName...) -> ProductionRule {
        return compound(names.map { required($0) })
    }
    
    func compound(strings: String...) -> ProductionRule {
        return compound(strings.map { required($0) })
    }
    
    // any
    
    func any(rules: [ProductionRule]) -> ProductionRule {
        return ProductionRule.Alternatives(rules: rules)
    }
    
    func any(rules: ProductionRule...) -> ProductionRule {
        let rules: [ProductionRule] = rules
        return any(rules)
    }
    
    func any(names: RuleName...) -> ProductionRule {
        return any(names.map { required($0) })
    }
    
    func any(strings: String...) -> ProductionRule {
        return any(strings.map { required($0) })
    }
    
    // zeroOrMore
    
    func zeroOrMore(rules: [ProductionRule]) -> ProductionRule {
        return GrammarRulesMath.zeroOrMore(rules)
    }
    
    func zeroOrMore(rules: ProductionRule...) -> ProductionRule {
        let rules: [ProductionRule] = rules
        return zeroOrMore(rules)
    }
    
    func zeroOrMore(names: RuleName...) -> ProductionRule {
        return zeroOrMore(names.map { required($0) })
    }
    
    func zeroOrMore(strings: String...) -> ProductionRule {
        return zeroOrMore(strings.map { required($0) })
    }
    
    // oneOrMore
    
    func oneOrMore(rules: [ProductionRule]) -> ProductionRule {
        return GrammarRulesMath.oneOrMore(rules)
    }
    
    func oneOrMore(rules: ProductionRule...) -> ProductionRule {
        let rules: [ProductionRule] = rules
        return oneOrMore(rules)
    }
    
    func oneOrMore(names: RuleName...) -> ProductionRule {
        return oneOrMore(names.map { required($0) })
    }
    
    func oneOrMore(strings: String...) -> ProductionRule {
        return oneOrMore(strings.map { required($0) })
    }
    
    // required
    
    func required(name: RuleName) -> ProductionRule {
        return GrammarRulesMath.rule(name)
    }
    
    func required(string: String) -> ProductionRule {
        return GrammarRulesMath.rule(string)
    }
    
    // optional
    
    func optional(rule: ProductionRule) -> ProductionRule {
        return GrammarRulesMath.optional(rule)
    }
    
    func optional(name: RuleName) -> ProductionRule {
        return GrammarRulesMath.optional(name)
    }
    
    func optional(string: String) -> ProductionRule {
        return GrammarRulesMath.optional(string)
    }
    
    // chars
    
    func char(value: UInt32) -> ProductionRule {
        return .Char(ranges: [CharRange(first: value, last: value)], invert: false)
    }
    
    func char(first: UInt32, _ last: UInt32) -> ProductionRule {
        return .Char(ranges: [CharRange(first: first, last: last)], invert: false)
    }
    
    func char(first: UnicodeScalar, _ last: UnicodeScalar) -> ProductionRule {
        return .Char(ranges: [CharRange(first: first, last: last)], invert: false)
    }
    
    func char(first: UnicodeScalar) -> ProductionRule {
        return .Char(ranges: [CharRange(first: first.value, last: first.value)], invert: false)
    }
    
    func char(chars: [UnicodeScalar]) -> ProductionRule {
        var ranges = [CharRange]()
        for char in chars {
            ranges.append(CharRange(first: char.value, last: char.value))
        }
        return .Char(ranges: ranges, invert: false)
    }
    
    func anyChar() -> ProductionRule {
        return .Char(ranges: [CharRange(first: UInt32.min, last: UInt32.max)], invert: false)
    }
    
    // *?
    // TODO: implement
    func lazy(rule: ProductionRule, stopRule: ProductionRule, stopRuleIsRequired: Bool) -> ProductionRule {
        return ProductionRule.Lazy(rule: rule, stopRule: stopRule, stopRuleIsRequired: stopRuleIsRequired)
    }
    
    func notChar(chars: [UnicodeScalar]) -> ProductionRule {
        var ranges = [CharRange]()
        for char in chars {
            ranges.append(CharRange(first: char.value, last: char.value))
        }
        return .Char(ranges: ranges, invert: true)
    }
    
    // check
    
    func check(closure: ProductionRuleCheckFunction) -> ProductionRule {
        return .Check(function: closure)
    }
    
    // times
    
    func times(times: UInt, _ name: RuleName) -> ProductionRule {
        var rules: [ProductionRule] = []
        for _ in 0..<times {
            rules.append(GrammarRulesMath.rule(name))
        }
        return compound(rules)
    }
    
    // misc
    
    func eof() -> ProductionRule {
        return ProductionRule.Eof
    }
    
    func empty() -> ProductionRule {
        return ProductionRule.Empty
    }
}

infix operator ~ { associativity left precedence 150 }
infix operator | { associativity left precedence 140 } // Swift operator | has ass
prefix operator ?? {}
prefix operator ~ {}

prefix func ??(name: RuleName) -> ProductionRule {
    return GrammarRulesMath.optional(name)
}

prefix func ??(string: String) -> ProductionRule {
    return GrammarRulesMath.optional(string)
}

prefix func ~(name: RuleName) -> ProductionRule {
    return GrammarRulesMath.rule(name)
}

prefix func ~(string: String) -> ProductionRule {
    return GrammarRulesMath.rule(string)
}

func ~(left: String, right: String) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: String, right: RuleName) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: String, right: ProductionRule) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: RuleName, right: String) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: RuleName, right: RuleName) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: RuleName, right: ProductionRule) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: ProductionRule, right: String) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: ProductionRule, right: RuleName) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func ~(left: ProductionRule, right: ProductionRule) -> ProductionRule {
    return GrammarRulesMath.compound(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

////


func |(left: String, right: String) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: String, right: RuleName) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: String, right: ProductionRule) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: RuleName, right: String) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: RuleName, right: RuleName) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: RuleName, right: ProductionRule) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: ProductionRule, right: String) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: ProductionRule, right: RuleName) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}

func |(left: ProductionRule, right: ProductionRule) -> ProductionRule {
    return GrammarRulesMath.any(
        [
            GrammarRulesMath.rule(left),
            GrammarRulesMath.rule(right)
        ]
    )
}