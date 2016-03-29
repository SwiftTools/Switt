struct LexerRuleDefinition {
    var identifier: RuleIdentifier
    var rule: LexerRule
    var channel: TokenChannel
}

struct LexerRules {
    private(set) var rules: [LexerRuleDefinition] = []
    private(set) var identifiers: Set<RuleIdentifier> = Set()
    private(set) var rulesByName: [RuleName: LexerRule] = [:]
    private(set) var fragmentsByIdentifier: [RuleIdentifier: LexerRule] = [:]
    private(set) var namedTerminals: [String: RuleName] = [:]
    
    mutating func appendRule(terminal terminal: String, rule: LexerRule) {
        if !rules.contains({ ruleDefinition in return rule == ruleDefinition.rule }) {
            let identifier = RuleIdentifier.Unnamed(terminal)
            if !identifiers.contains(identifier) {
                identifiers.insert(identifier)
                rules.append(
                    LexerRuleDefinition(
                        identifier: identifier,
                        rule: rule,
                        channel: .Default
                    )
                )
            }
        }
    }
    
    mutating func appendRule(name name: RuleName, rule: LexerRule, channel: TokenChannel) {
        if let index = rules.indexOf({ ruleDefinition in return rule == ruleDefinition.rule }) {
            if let ruleDefinition = rules.at(index) {
                switch ruleDefinition.identifier {
                case .Named:
                    // don't touch named rules
                    break
                case .Unnamed, .Unique:
                    // replace with named equivalent
                    rules.removeAtIndex(index)
                }
            } else {
                assertionFailure()
            }
        }
        
        switch rule {
        case .Terminal(let terminal):
            namedTerminals[terminal] = name
        default:
            break
        }
        
        // TODO: it seems that two checks is excess (see first check at the beginning)
        
        let identifier = RuleIdentifier.Named(name)
        if !identifiers.contains(identifier) {
            identifiers.insert(identifier)
            rules.append(
                LexerRuleDefinition(
                    identifier: identifier,
                    rule: rule,
                    channel: channel
                )
            )
        }
        
        rulesByName[name] = rule
    }
    
    mutating func appendFragment(identifier identifier: RuleIdentifier, rule: LexerRule) {
        fragmentsByIdentifier[identifier] = rule
    }
}