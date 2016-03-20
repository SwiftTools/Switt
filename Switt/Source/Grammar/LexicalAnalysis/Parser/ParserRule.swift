indirect enum ParserRule {
    case Check(function: ProductionRuleCheckFunction)
    case Char(ranges: [CharRange], invert: Bool)
    case RuleReference(ruleName: RuleName)
    case Sequence(rules: [ParserRule])
    case Alternatives(rules: [ParserRule])
    case Optional(rule: ParserRule)
    case Terminal(terminal: String)
    case Repetition(atLeast: UInt, rule: ParserRule)
    case Empty
    case Eof
}