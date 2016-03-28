indirect enum ParserRule {
    case Check(function: ProductionRuleCheckFunction)
    
    // Reference
    case RuleReference(identifier: RuleIdentifier)
    case NamedTerminal(ruleName: RuleName)
    
    // Multiple rules
    case Sequence(rules: [ParserRule])
    case Alternatives(rules: [ParserRule])
    
    // Recursive
    case Repetition(atLeast: UInt, rule: ParserRule)
    case Optional(rule: ParserRule)
    
    // Simple
    case Terminal(terminal: String)
    case Empty
    case Eof
}