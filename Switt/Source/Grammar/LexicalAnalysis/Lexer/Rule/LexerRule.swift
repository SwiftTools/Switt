indirect enum LexerRule: CustomDebugStringConvertible {
    case Char(ranges: [CharRange], invert: Bool)
    case RuleReference(ruleName: RuleName)
    case Sequence(rules: [LexerRule])
    case Alternatives(rules: [LexerRule])
    case Terminal(terminal: String)
    case Repetition(rule: LexerRule)
}

extension LexerRule {
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
        }
    }
}
