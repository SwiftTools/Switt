private struct DetectedRecursion {
    var sequencesWithRecursion: [[ProductionRule]] = []
    var sequencesWithoutRecursion: [[ProductionRule]] = []
}

private struct RemovingRecursionRules {
    var rule: ProductionRule
    
    var fragmentIdentifier: RuleIdentifier
    var fragment: ProductionRule
}

private extension ProductionRule {
    func containsDirectLeftRecursion(ruleIdentifier: RuleIdentifier) -> Bool {
        switch self {
        case .CustomParser, .Eof, .Terminal, .Char, .Empty, .CustomTokenizer:
            return false
        case .RuleReference(let identifier):
            return identifier == ruleIdentifier
        case .Multiple(_, let rule):
            return rule.containsDirectLeftRecursion(ruleIdentifier)
        case .Optional(let rule):
            return rule.containsDirectLeftRecursion(ruleIdentifier)
        case .Alternatives(let rules):
            return rules.contains { $0.containsDirectLeftRecursion(ruleIdentifier) }
        case .Sequence(let rules):
            return rules.first?.containsDirectLeftRecursion(ruleIdentifier) == true
        case .Lazy(let startRule, _, _):
            return startRule.containsDirectLeftRecursion(ruleIdentifier)
        }
    }
}

class DirectLeftRecursionRemoverImpl: DirectLeftRecursionRemover {
    func removeDirectLeftRecursion(ruleRegistrationInfo: RuleRegistrationInfo) -> [RuleRegistrationInfo] {
        switch ruleRegistrationInfo {
        case .LexerFragment(let info):
            return removeDirectLeftRecursion(info)
        case .ParserFragment(let info):
            return removeDirectLeftRecursion(info)
        case .ParserRule(let info):
            return removeDirectLeftRecursion(info)
        case .LexerRule(let info):
            return removeDirectLeftRecursion(info)
        }
    }
    
    func removeDirectLeftRecursion(lexerRule: LexerRuleRegistrationInfo) -> [RuleRegistrationInfo] {
        let removingRecursionRules = removeLeftRecursion(
            ruleIdentifier: RuleIdentifier.Named(lexerRule.name),
            rule: lexerRule.rule
        )
        if let removingRecursionRules = removingRecursionRules {
            return [
                RuleRegistrationInfo.LexerRule(
                    LexerRuleRegistrationInfo(
                        name: lexerRule.name,
                        rule: removingRecursionRules.rule,
                        channel: lexerRule.channel
                    )
                ),
                
                RuleRegistrationInfo.LexerFragment(
                    LexerFragmentRegistrationInfo(
                        identifier: removingRecursionRules.fragmentIdentifier,
                        rule: removingRecursionRules.fragment
                    )
                )
            ]
        } else {
            return [RuleRegistrationInfo.LexerRule(lexerRule)]
        }
    }
    
    func removeDirectLeftRecursion(lexerFragment: LexerFragmentRegistrationInfo) -> [RuleRegistrationInfo] {
        let removingRecursionRules = removeLeftRecursion(
            ruleIdentifier: lexerFragment.identifier,
            rule: lexerFragment.rule
        )
        
        if let removingRecursionRules = removingRecursionRules {
            return [
                RuleRegistrationInfo.LexerFragment(
                    LexerFragmentRegistrationInfo(
                        identifier: lexerFragment.identifier,
                        rule: removingRecursionRules.rule
                    )
                ),
                RuleRegistrationInfo.LexerFragment(
                    LexerFragmentRegistrationInfo(
                        identifier: removingRecursionRules.fragmentIdentifier,
                        rule: removingRecursionRules.fragment
                    )
                )
            ]
        } else {
            return [RuleRegistrationInfo.LexerFragment(lexerFragment)]
        }
    }
    
    func removeDirectLeftRecursion(parserRule: ParserRuleRegistrationInfo) -> [RuleRegistrationInfo] {
        let removingRecursionRules = removeLeftRecursion(
            ruleIdentifier: RuleIdentifier.Named(parserRule.name),
            rule: parserRule.rule
        )
        if let removingRecursionRules = removingRecursionRules {
            return [
                RuleRegistrationInfo.ParserRule(
                    ParserRuleRegistrationInfo(
                        name: parserRule.name,
                        rule: removingRecursionRules.rule
                    )
                ),
                RuleRegistrationInfo.ParserFragment(
                    ParserFragmentRegistrationInfo(
                        identifier: removingRecursionRules.fragmentIdentifier,
                        rule: removingRecursionRules.fragment
                    )
                )
            ]
        } else {
            return [RuleRegistrationInfo.ParserRule(parserRule)]
        }
    }
    
    func removeDirectLeftRecursion(parserFragment: ParserFragmentRegistrationInfo) -> [RuleRegistrationInfo] {
        let removingRecursionRules = removeLeftRecursion(
            ruleIdentifier: parserFragment.identifier,
            rule: parserFragment.rule
        )
        
        if let removingRecursionRules = removingRecursionRules {
            return [
                RuleRegistrationInfo.ParserFragment(
                    ParserFragmentRegistrationInfo(
                        identifier: parserFragment.identifier,
                        rule: removingRecursionRules.rule
                    )
                ),
                RuleRegistrationInfo.ParserFragment(
                    ParserFragmentRegistrationInfo(
                        identifier: removingRecursionRules.fragmentIdentifier,
                        rule: removingRecursionRules.fragment
                    )
                )
            ]
        } else {
            return [RuleRegistrationInfo.ParserFragment(parserFragment)]
        }
    }
    
    private func removeLeftRecursion(ruleIdentifier ruleIdentifier: RuleIdentifier, rule: ProductionRule) -> RemovingRecursionRules? {
        if let detectRecursion = detectRecursion(ruleIdentifier: ruleIdentifier, rule: rule) {
            
            let fragmentIdentifier = RuleIdentifier.Unique(UniqueIdentifier())
            
            let newRule = ProductionRule.Alternatives(
                rules: detectRecursion.sequencesWithoutRecursion.map { sequence in
                    return ProductionRule.Sequence(
                        rules: sequence + [ProductionRule.RuleReference(identifier: fragmentIdentifier)]
                    )
                }
            )
            let fragmentRule = ProductionRule.Alternatives(
                rules: detectRecursion.sequencesWithRecursion.map { sequence in
                    return ProductionRule.Sequence(
                        rules: sequence + [ProductionRule.RuleReference(identifier: fragmentIdentifier)]
                    )
                } + [ProductionRule.Empty]
            )
            
            assert(!newRule.containsDirectLeftRecursion(ruleIdentifier))
            assert(!fragmentRule.containsDirectLeftRecursion(fragmentIdentifier))
            
            return RemovingRecursionRules(
                rule: newRule,
                fragmentIdentifier: fragmentIdentifier,
                fragment: fragmentRule
            )
        } else {
            return nil
        }
    }
    
    private func detectRecursion(ruleIdentifier ruleIdentifier: RuleIdentifier, rule: ProductionRule) -> DetectedRecursion? {
        if rule.containsDirectLeftRecursion(ruleIdentifier) {
            let transformer = RepeatingProductionRuleTransformer(
                transformer: CompoundProductionRuleTransformer(
                    transformers: [
                        StripRepetitionProductionRuleTransformer(),
                        StripOptionalsProductionRuleTransformer(),
                        UnrollSequenceProductionRuleTransformer(),
                        MergeCollectionsProductionRuleTransformer(),
                        StripEmptyProductionRuleTransformer()
                    ]
                )
            )
            
            let rule = transformer.transform(rule)
            
            switch rule {
            case .Alternatives(let alternatives):
                var sequencesWithRecursion: [[ProductionRule]] = []
                var sequencesWithoutRecursion: [[ProductionRule]] = []
                
                for alternative in alternatives {
                    switch alternative {
                    case .Sequence(let sequence):
                        if let rule = sequence.first {
                            switch rule {
                            case .RuleReference(let identifier):
                                if ruleIdentifier == identifier {
                                    sequencesWithRecursion.append(sequence.dropFirst().map { $0 })
                                } else {
                                    sequencesWithoutRecursion.append(sequence)
                                }
                            default:
                                sequencesWithoutRecursion.append(sequence)
                            }
                        } else {
                            // ignore empty sequence
                        }
                    default:
                        sequencesWithoutRecursion.append([alternative])
                    }
                }
                
                if sequencesWithRecursion.count > 0 {
                    if sequencesWithoutRecursion.count > 0 {
                        return DetectedRecursion(
                            sequencesWithRecursion: sequencesWithRecursion,
                            sequencesWithoutRecursion: sequencesWithoutRecursion
                        )
                    } else {
                        abort() // TODO
                    }
                } else {
                    return nil
                }
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}