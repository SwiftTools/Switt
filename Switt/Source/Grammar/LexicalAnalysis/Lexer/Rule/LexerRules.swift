struct LexerRuleDefinition {
    var identifier: RuleIdentifier
    var rule: LexerRule
    var channel: LexerChannel
}

struct LexerRules {
    private(set) var rules: [LexerRuleDefinition] = []
    private(set) var identifiers: Set<RuleIdentifier> = Set()
    private(set) var rulesByName: [RuleName: LexerRule] = [:]
    private(set) var fragmentsByIdentifier: [RuleIdentifier: LexerRule] = [:]
    
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
    
    mutating func appendRule(name name: RuleName, rule: LexerRule, channel: LexerChannel) {
        if let index = rules.indexOf({ ruleDefinition in return rule == ruleDefinition.rule }) {
            let ruleDefinition = rules[index]
            switch ruleDefinition.identifier {
            case .Named:
                // don't touch named rules
                break
            case .Unnamed, .Unique:
                // replace with named equivalent
                rules.removeAtIndex(index)
            }
        }
        
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
    
//    mutating func appendRule(ruleDefinition ruleDefinition: LexerRuleDefinition) {
//        switch ruleDefinition.identifier {
//        case .Named(let name):
//            appendRule(name: name, rule: ruleDefinition.rule, channel: ruleDefinition.channel)
//        case .Unnamed(let terminal):
//            appendRule(terminal: terminal, rule: ruleDefinition.rule)
//            case .Unique(<#T##UniqueIdentifier#>)
//        }
//    }
    
}