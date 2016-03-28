enum RuleRegistrationInfo {
    case LexerRule(LexerRuleRegistrationInfo)
    case ParserRule(ParserRuleRegistrationInfo)
    case LexerFragment(LexerFragmentRegistrationInfo)
    case ParserFragment(ParserFragmentRegistrationInfo)
    
    var rule: ProductionRule {
        switch self {
        case .LexerRule(let info):
            return info.rule
        case .ParserRule(let info):
            return info.rule
        case .LexerFragment(let info):
            return info.rule
        case .ParserFragment(let info):
            return info.rule
        }
    }
}