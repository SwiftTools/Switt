protocol GrammarRulesBuilder: class {
    var grammarRules: GrammarRules { get set }
    
    func registerRules()
}

extension GrammarRulesBuilder {
    // building
    
    func clearRules() {
        grammarRules = GrammarRules()
    }
    
    func append(grammarBuilder: GrammarRulesBuilder) {
        grammarBuilder.clearRules()
        grammarBuilder.registerRules()
        
        for (type, rule) in grammarBuilder.grammarRules.rules {
            grammarRules.rules[type] = rule
        }

        for (type, rule) in grammarBuilder.grammarRules.fragments {
            grammarRules.fragments[type] = rule
        }
    }
    
    func register(name: RuleName, _ rule: ProductionRule) {
        grammarRules.rules[name] = rule
    }
    
    func registerFragment(name: RuleName, _ rule: ProductionRule) {
        grammarRules.fragments[name] = rule
    }
    
    // compound
    
    func compound(lexemes: [ProductionRule]) -> ProductionRule {
        return GrammarRulesMath.compound(lexemes)
    }
    
    func compound(lexemes: ProductionRule...) -> ProductionRule {
        let lexemes: [ProductionRule] = lexemes
        return compound(lexemes)
    }
    
    func compound(names: RuleName...) -> ProductionRule {
        return compound(names.map { required($0) })
    }
    
    func compound(strings: String...) -> ProductionRule {
        return compound(strings.map { required($0) })
    }
    
    // any
    
    func any(lexemes: [ProductionRule]) -> ProductionRule {
        return GrammarRulesMath.any(lexemes)
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
        return .CharRanges(true, [CharRange(first: value, last: value)])
    }
    
    func char(first: UInt32, _ last: UInt32) -> ProductionRule {
        return .CharRanges(true, [CharRange(first: first, last: last)])
    }
    
    func char(first: UnicodeScalar, _ last: UnicodeScalar) -> ProductionRule {
        return .CharRanges(true, [CharRange(first: first.value, last: last.value)])
    }
    
    func char(first: UnicodeScalar) -> ProductionRule {
        return .CharRanges(true, [CharRange(first: first.value, last: first.value)])
    }
    
    func char(chars: [UnicodeScalar]) -> ProductionRule {
        var ranges = [CharRange]()
        for char in chars {
            ranges.append(CharRange(first: char.value, last: char.value))
        }
        return .CharRanges(true, ranges)
    }
    
    func anyChar() -> ProductionRule {
        return .CharRanges(true, [CharRange(first: UInt32.min, last: UInt32.max)])
    }
    
    // *?
    // TODO: implement
    func lazy(lexeme: ProductionRule) -> ProductionRule {
        return lexeme
    }
    
    func notChar(chars: [UnicodeScalar]) -> ProductionRule {
        var ranges = [CharRange]()
        for char in chars {
            ranges.append(CharRange(first: char.value, last: char.value))
        }
        return .CharRanges(false, ranges)
    }
    
    // check
    
    func check(closure: ProductionRuleCheckFunction) -> ProductionRule {
        return .Check(closure)
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
}

infix operator ~ { associativity left precedence 140 }
infix operator | { associativity left precedence 130 }
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