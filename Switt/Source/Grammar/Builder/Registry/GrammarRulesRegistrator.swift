protocol GrammarRulesRegistrator: GrammarRulesBuilder {
    var grammarRegistry: GrammarRegistry { get set }
    
    func clearRules()
    func registerRules()
}

extension GrammarRulesRegistrator {
    func clearRules() {
        grammarRegistry = GrammarRegistry()
    }
    
    func append(grammarBuilder: GrammarRulesRegistrator) {
        grammarBuilder.clearRules()
        grammarBuilder.registerRules()
        
        for rule in grammarBuilder.grammarRegistry.rules {
            grammarRegistry.rules.append(rule)
        }
    }
    
    func parserRule(name: RuleName, _ rule: ProductionRule) {
        grammarRegistry.rules.append(
            .ParserRule(
                ParserRuleRegistrationInfo(
                    name: name,
                    rule: rule
                )
            )
        )
    }
    
    func lexerRule(name: RuleName, _ rule: ProductionRule, channel: TokenChannel = TokenChannel.Default) {
        grammarRegistry.rules.append(
            .LexerRule(
                LexerRuleRegistrationInfo(
                    name: name,
                    rule: rule,
                    channel: channel
                )
            )
        )
    }
    
    func parserFragment(name: RuleName, _ rule: ProductionRule) {
        grammarRegistry.rules.append(
            .ParserFragment(
                ParserFragmentRegistrationInfo(
                    identifier: RuleIdentifier.Named(name),
                    rule: rule
                )
            )
        )
    }
    
    func lexerFragment(name: RuleName, _ rule: ProductionRule) {
        grammarRegistry.rules.append(
            .LexerFragment(
                LexerFragmentRegistrationInfo(
                    identifier: RuleIdentifier.Named(name),
                    rule: rule
                )
            )
        )
    }

    func grammar(firstRule firstRule: RuleName) -> Grammar {
        clearRules()
        registerRules()
        
        let remover: DirectLeftRecursionRemover = DirectLeftRecursionRemoverImpl()
        var clearedRules: [RuleRegistrationInfo] = []
        
        // Eliminate direct left recursion:
        for ruleRegistrationInfo in grammarRegistry.rules {
            let newRules = remover.removeDirectLeftRecursion(ruleRegistrationInfo)
            clearedRules.appendContentsOf(newRules)
        }
        
        return grammar(clearedRules: clearedRules, firstRule: firstRule)
    }
    
    func grammar(clearedRules clearedRules: [RuleRegistrationInfo], firstRule: RuleName) -> Grammar {
        var grammarRules = GrammarRules()
        
        for ruleRegistrationInfo in clearedRules {
            switch ruleRegistrationInfo {
            case .LexerRule(let lexerRuleInfo):
                if let lexerRule = LexerRuleConverter.convertToLexerRule(lexerRuleInfo.rule) {
                    grammarRules.lexerRules.appendRule(
                        name: lexerRuleInfo.name,
                        rule: lexerRule,
                        channel: lexerRuleInfo.channel
                    )
                } else {
                    abort() // TODO
                }
            case .LexerFragment(let lexerFragmentInfo):
                if let lexerRule = LexerRuleConverter.convertToLexerRule(lexerFragmentInfo.rule) {
                    grammarRules.lexerRules.appendFragment(
                        identifier: lexerFragmentInfo.identifier,
                        rule: lexerRule
                    )
                } else {
                    abort() // TODO
                }
            case .ParserRule(let parserRuleInfo):
                for terminal in GrammarRulesMath.allTerminals(parserRuleInfo.rule) {
                    grammarRules.lexerRules.appendRule(
                        terminal: terminal,
                        rule: LexerRule.Terminal(terminal: terminal)
                    )
                }
            default:
                break
            }
        }
        
        let parserRuleConverter = ParserRuleConverterImpl(lexerRules: grammarRules.lexerRules)
        
        for ruleRegistrationInfo in clearedRules {
            switch ruleRegistrationInfo {
            case .ParserRule(let parserRuleInfo):
                let parserRule = parserRuleConverter.convertToParserRule(
                    productionRule: parserRuleInfo.rule
                )
                if let parserRule = parserRule {
                    grammarRules.parserRules.rulesByName[parserRuleInfo.name] = parserRule
                } else {
                    abort() // TODO
                }
            case .ParserFragment(let parserFragmentInfo):
                let parserRule = parserRuleConverter.convertToParserRule(
                    productionRule: parserFragmentInfo.rule
                )
                if let parserRule = parserRule {
                    grammarRules.parserRules.fragmentsByIdentifier[parserFragmentInfo.identifier] = parserRule
                } else {
                    abort() // TODO
                }
            default:
                break
            }
        }
        
        return Grammar(
            grammarRules: grammarRules,
            firstRule: firstRule
        )
    }
}