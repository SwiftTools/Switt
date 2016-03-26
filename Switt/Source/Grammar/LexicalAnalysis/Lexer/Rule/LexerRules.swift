struct LexerRuleDefinition {
    var identifier: RuleIdentifier
    var rule: LexerRule
}

struct LexerRules {
    private(set) var rules: [LexerRuleDefinition] = []
    private(set) var identifiers: Set<RuleIdentifier> = Set()
    private(set) var rulesByName: [RuleName: LexerRule] = [:]
    private(set) var fragmentsByName: [RuleName: LexerRule] = [:]
    
    mutating func appendRule(terminal terminal: String, rule: LexerRule) {
        let identifier = RuleIdentifier.Unnamed(terminal)
        if !identifiers.contains(identifier) {
            identifiers.insert(identifier)
            rules.append(
                LexerRuleDefinition(
                    identifier: identifier,
                    rule: rule
                )
            )
        }
    }
    
    mutating func appendRule(name name: RuleName, rule: LexerRule) {
        let identifier = RuleIdentifier.Named(name)
        if !identifiers.contains(identifier) {
            identifiers.insert(identifier)
            rules.append(
                LexerRuleDefinition(
                    identifier: identifier,
                    rule: rule
                )
            )
        }
        
        rulesByName[name] = rule
    }
    
    mutating func appendRule(ruleDefinition ruleDefinition: LexerRuleDefinition) {
        switch ruleDefinition.identifier {
        case .Named(let name):
            appendRule(name: name, rule: ruleDefinition.rule)
        case .Unnamed(let terminal):
            appendRule(terminal: terminal, rule: ruleDefinition.rule)
        }
    }
    
    
    mutating func appendFragment(name name: RuleName, rule: LexerRule) {
        fragmentsByName[name] = rule
    }
}