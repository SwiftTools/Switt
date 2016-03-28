enum ReferencedTokenParser {
    case RuleParser(TokenParser, RuleName)
    case FragmentParser(TokenParser)
    
    var tokenParser: TokenParser {
        switch self {
        case .RuleParser(let tokenParser, _):
            return tokenParser
        case .FragmentParser(let tokenParser):
            return tokenParser
        }
    }
}

class TokenParserFactoryImpl: TokenParserFactory {
    private let parserRules: ParserRules
    
    init(parserRules: ParserRules) {
        self.parserRules = parserRules
    }
    
    func tokenParser(ruleIdentifier: RuleIdentifier) -> ReferencedTokenParser? {
        switch ruleIdentifier {
        case .Named(let ruleName):
            if let parserRule = parserRules.rulesByName[ruleName] {
                return ReferencedTokenParser.RuleParser(tokenParser(parserRule), ruleName)
            }
        default:
            break
        }
        
        if let parserRule = parserRules.fragmentsByIdentifier[ruleIdentifier] {
            return ReferencedTokenParser.FragmentParser(tokenParser(parserRule))
        } else {
            return nil
        }
    }
    
    func tokenParser(rule: ParserRule) -> TokenParser {
        switch rule {
        case .Alternatives(let rules):
            return AlternativesTokenParser(
                rules: rules,
                tokenParserFactory: self
            )
        case .Check(let function):
            return CheckTokenParser(
                function: function
            )
        case .Empty:
            return EmptyTokenParser()
        case .Eof:
            return EofTokenParser()
        case .Optional(let rule):
            return OptionalTokenParser(
                rule: rule,
                tokenParserFactory: self
            )
        case .Repetition(let atLeast, let rule):
            return RepetitionTokenParser(
                rule: rule,
                atLeast: atLeast,
                tokenParserFactory: self
            )
        case .Terminal(let terminal):
            return TerminalTokenParser(
                terminal: terminal
            )
        case .RuleReference(let ruleIdentifier):
            return RuleReferenceTokenParser(
                ruleIdentifier: ruleIdentifier,
                tokenParserFactory: TokenParserFactoryImpl(
                    parserRules: parserRules
                )
            )
        case .NamedTerminal(let ruleName):
            return NamedTerminalTokenParser(
                ruleName: ruleName
            )
        case .Sequence(let rules):
            return SequenceTokenParser(
                rules: rules,
                tokenParserFactory: self
            )
        }
    }
}