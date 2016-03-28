indirect enum LexerRule: CustomDebugStringConvertible, Equatable {
    case Char(ranges: [CharRange], invert: Bool)
    case RuleReference(identifier: RuleIdentifier)
    case Sequence(rules: [LexerRule])
    case Alternatives(rules: [LexerRule])
    case Terminal(terminal: String)
    case Repetition(rule: LexerRule)
    case Lazy(rule: LexerRule, stopRule: LexerRule, stopRuleIsRequired: Bool)

    var debugDescription: String {
        switch self {
        case .Char(let ranges, let invert):
            let invertString = invert ? "^" : ""
            return invertString + (ranges.map { $0.debugDescription }).joinWithSeparator(" | ")
        case .Sequence(let rules):
            return "seq" + StringUtils.wrapAndIndent(
                prefix: "(",
                infix: (rules.map { $0.debugDescription }).joinWithSeparator("," + StringUtils.newLine),
                postfix: ")"
            )
        case .Repetition(let rule):
            return "repeat" + StringUtils.wrapAndIndent(
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
        case .RuleReference(let ruleName):
            return ruleName.debugDescription
        case .Terminal(let terminal):
            return "'\(terminal)'"
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
        }
    }
}

func ==(left: LexerRule, right: LexerRule) -> Bool {
    switch (left, right) {
    case (.Char(let ranges1, let invert1), .Char(let ranges2, let invert2)):
        return ranges1 == ranges2 && invert1 == invert2
    case (.Sequence(let rules1), .Sequence(let rules2)):
        return rules1 == rules2
    case (.Repetition(let rule1), .Repetition(let rule2)):
        return rule1 == rule2
    case (.Alternatives(let rules1), .Alternatives(let rules2)):
        return rules1 == rules2
    case (.RuleReference(let ruleName1), .RuleReference(let ruleName2)):
        return ruleName1 == ruleName2
    case (.Terminal(let terminal1), .Terminal(let terminal2)):
        return terminal1 == terminal2
    default:
        return false
    }
}
