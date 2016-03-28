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
    
    func lexerRule(name: RuleName, _ rule: ProductionRule, channel: LexerChannel = LexerChannel.Default) {
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
        
        for ruleRegistrationInfo in clearedRules {
            switch ruleRegistrationInfo {
            case .ParserRule(let parserRuleInfo):
                let parserRule = convertToParserRule(
                    productionRule: parserRuleInfo.rule,
                    lexerRules: grammarRules.lexerRules
                )
                if let parserRule = parserRule {
                    grammarRules.parserRules.rulesByName[parserRuleInfo.name] = parserRule
                } else {
                    abort() // TODO
                }
            case .ParserFragment(let parserFragmentInfo):
                let parserRule = convertToParserRule(
                    productionRule: parserFragmentInfo.rule,
                    lexerRules: grammarRules.lexerRules
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
    
    // TODO: Move
    private func convertToParserRule(productionRule rule: ProductionRule, lexerRules: LexerRules) -> ParserRule? {
        switch rule {
        case .Char:
            return nil
        case .Check(let checkFunction):
            return ParserRule.Check(function: checkFunction)
        case .Sequence(let rules):
            return ParserRule.Sequence(
                rules: rules.flatMap {
                    convertToParserRule(productionRule: $0, lexerRules: lexerRules)
                }
            )
        case .Empty:
            return ParserRule.Empty
        case .Eof:
            return ParserRule.Eof
        case .Multiple(let atLeast, let rule):
            return convertToParserRule(productionRule: rule, lexerRules: lexerRules)
                .flatMap { rule in ParserRule.Repetition(atLeast: atLeast, rule: rule) }
        case .Optional(let rule):
            return convertToParserRule(productionRule: rule, lexerRules: lexerRules)
                .flatMap { rule in ParserRule.Optional(rule: rule) }
        case .Alternatives(let rules):
            return ParserRule.Alternatives(
                rules: rules.flatMap {
                    convertToParserRule(productionRule: $0, lexerRules: lexerRules)
                }
            )
        case .RuleReference(let ruleIdentifier):
            if lexerRules.fragmentsByIdentifier[ruleIdentifier] != nil {
                // Reference to lexer fragment: error
                abort() // TODO
            } else {
                switch ruleIdentifier {
                case .Named(let ruleName):
                    if lexerRules.rulesByName[ruleName] != nil {
                        // Reference to lexer rule
                        return ParserRule.NamedTerminal(ruleName: ruleName)
                    } else {
                        return ParserRule.RuleReference(identifier: ruleIdentifier)
                    }
                default:
                    return ParserRule.RuleReference(identifier: ruleIdentifier)
                }
            }
            
        case .Terminal(let terminal):
            return ParserRule.Terminal(terminal: terminal)
        case .Lazy:
            return nil
        }
    }
}