indirect enum ProductionRule: CustomDebugStringConvertible, Equatable {
    case CustomParser(factory: CustomTokenParserFactory)
    case Char(ranges: [CharRange], invert: Bool)
    case RuleReference(identifier: RuleIdentifier)
    case Sequence(rules: [ProductionRule])
    case Alternatives(rules: [ProductionRule])
    case Optional(rule: ProductionRule)
    case Terminal(terminal: String)
    // TODO: remove stop rule.
    // Add start and stop rule to LexerRule.
    // Improve converter to lexer rule
    case Lazy(rule: ProductionRule, stopRule: ProductionRule, stopRuleIsRequired: Bool)
    case Multiple(atLeast: UInt, rule: ProductionRule)
    case Empty
    case Eof
}

func ==(left: ProductionRule, right: ProductionRule) -> Bool {
    switch (left, right) {
    case (.CustomParser(let factory1), .CustomParser(let factory2)):
        return factory1 === factory2
    case (.Char(let ranges1, let invert1), .Char(let ranges2, let invert2)):
        return ranges1 == ranges2 && invert1 == invert2
    case (.Sequence(let rules1), .Sequence(let rules2)):
        return rules1 == rules2
    case (.Empty, .Empty):
        return true
    case (.Eof, .Eof):
        return true
    case (.Multiple(let times1, let rule1), .Multiple(let times2, let rule2)):
        return times1 == times2 && rule1 == rule2
    case (.Optional(let rule1), .Optional(let rule2)):
        return rule1 == rule2
    case (.Alternatives(let rules1), .Alternatives(let rules2)):
        return rules1 == rules2
    case (.RuleReference(let ruleName1), .RuleReference(let ruleName2)):
        return ruleName1 == ruleName2
    case (.Terminal(let terminal1), .Terminal(let terminal2)):
        return terminal1 == terminal2
    case (.Lazy(let rule1, let stopRule1, let required1), .Lazy(let rule2, let stopRule2, let required2)):
        return rule1 == rule2 && stopRule1 == stopRule2 && required1 == required2
    default:
        return false
    }
}

extension ProductionRule {
    var debugDescription: String {
        switch self {
        case .Char(let ranges, let invert):
            let invertString = invert ? "^" : ""
            return invertString + (ranges.map { $0.debugDescription }).joinWithSeparator(" | ")
        case .CustomParser(let factory):
            return "custom parser(\(factory.dynamicType))"
        case .Sequence(let rules):
            return "compound" + StringUtils.wrapAndIndent(
                prefix: "(",
                infix: (rules.map { $0.debugDescription }).joinWithSeparator("," + StringUtils.newLine),
                postfix: ")"
            )
        case .Empty:
            return "<ε>"
        case .Eof:
            return "<EOF>"
        case .Multiple(let times, let rule):
            return "atLeast(\(times)" + StringUtils.wrapAndIndent(
                prefix: ", ",
                infix: rule.debugDescription,
                postfix: ")"
            )
        case .Optional(let rule):
            return "optional" + StringUtils.wrapAndIndent(
                prefix: "(",
                infix: rule.debugDescription,
                postfix: ")"
            )
        case .Alternatives(let rules):
            return "any" + StringUtils.wrapAndIndent(
                prefix: "(",
                infix: (rules.map { $0.debugDescription }).joinWithSeparator("," + StringUtils.newLine),
                postfix: ")"
            )
        case .Lazy(let rule, let stopRule, let required):
            return "lazy"
                + StringUtils.wrapAndIndent(
                    prefix: "(",
                    infix: rule.debugDescription,
                    postfix: ")"
                ) + StringUtils.wrapAndIndent(
                    prefix: ", stopRule" + (required ? "(required)" : "") + ": (",
                    infix: stopRule.debugDescription,
                    postfix: ")"
            )
        case .RuleReference(let identifier):
            return identifier.debugDescription
        case .Terminal(let terminal):
            return "'\(terminal)'"
        }
    }
}

