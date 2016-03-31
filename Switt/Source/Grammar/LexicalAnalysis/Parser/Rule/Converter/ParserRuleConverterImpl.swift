final class ParserRuleConverterImpl: ParserRuleConverter {
    private let lexerRules: LexerRules
    
    init(lexerRules: LexerRules) {
        self.lexerRules = lexerRules
    }
    
    func convertToParserRule(productionRule rule: ProductionRule) -> ParserRule? {
        let transformer = RepeatingProductionRuleTransformer(
            transformer: CompoundProductionRuleTransformer(
                transformers: [
                    StripRepetitionProductionRuleTransformer(),
                    StripOptionalsProductionRuleTransformer(),
                    MergeCollectionsProductionRuleTransformer(),
                    StripEmptyProductionRuleTransformer(),
                    UnrollSequenceProductionRuleTransformer()
                ]
            )
        )
        
        let rule = transformer.transform(rule)
        
        switch rule {
        case .Char:
            return nil
        case .CustomParser(let factory):
            return ParserRule.CustomParser(
                factory: ParserRuleCustomTokenParserFactoryImpl(
                    customTokenParserFactory: factory,
                    parserRuleConverter: self
                )
            )
        case .CustomTokenizer:
            return nil
            
        case .Sequence(let rules):
            return ParserRule.Sequence(
                rules: rules.flatMap {
                    convertToParserRule(productionRule: $0)
                }
            )
        case .Empty:
            return ParserRule.Empty
        case .Eof:
            return ParserRule.Eof
        case .Multiple(let atLeast, let rule):
            return convertToParserRule(productionRule: rule)
                .flatMap { rule in ParserRule.Repetition(atLeast: atLeast, rule: rule) }
        case .Optional(let rule):
            return convertToParserRule(productionRule: rule)
                .flatMap { rule in ParserRule.Optional(rule: rule) }
        case .Alternatives(let rules):
            return ParserRule.Alternatives(
                rules: rules.flatMap {
                    convertToParserRule(productionRule: $0)
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
            if let ruleName = lexerRules.namedTerminals[terminal] {
                return ParserRule.NamedTerminal(ruleName: ruleName)
            } else {
                return ParserRule.Terminal(terminal: terminal)
            }
        case .Lazy:
            return nil
        }
    }
}