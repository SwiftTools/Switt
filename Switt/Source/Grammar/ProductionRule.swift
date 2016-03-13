typealias ProductionRuleCheckFunction = () -> (Bool)

indirect enum ProductionRule {
    case Check(ProductionRuleCheckFunction)
    case CharRanges(Bool, [CharRange])
    case Reference(RuleName)
    case Compound([ProductionRule])
    case Or([ProductionRule])
    case Optional(ProductionRule)
    case StringRule(String) // rename to Terminal
    case Multiple(UInt, ProductionRule)
    case Empty
    case Eof
}
