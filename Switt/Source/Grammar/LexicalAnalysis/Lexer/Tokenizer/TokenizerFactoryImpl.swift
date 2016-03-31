class TokenizerFactoryImpl: TokenizerFactory {
    private let lexerRules: LexerRules
    
    init(lexerRules: LexerRules) {
        self.lexerRules = lexerRules
    }
    
    func tokenizer(ruleIdentifier: RuleIdentifier) -> Tokenizer? {
        let lexerRule: LexerRule?
        switch ruleIdentifier {
        case .Named(let ruleName):
            lexerRule = lexerRules.rulesByName[ruleName] ?? lexerRules.fragmentsByIdentifier[ruleIdentifier]
        default:
            lexerRule = lexerRules.fragmentsByIdentifier[ruleIdentifier]
        }
        return lexerRule.flatMap(tokenizer)
    }
    
    func tokenizer(lexerRule: LexerRule) -> Tokenizer {
        let tokenizer: Tokenizer
        
        switch lexerRule {
        case .Char(let ranges, let invert):
            tokenizer = CharTokenizer(
                charRanges: ranges,
                invert: invert
            )
        case .Sequence(let rules):
            tokenizer = SequenceTokenizer(
                rules: rules,
                tokenizerFactory: self
            )
        case .Repetition(let rule):
            tokenizer = RepetitionTokenizer(
                rule: rule,
                tokenizerFactory: self
            )
        case .Alternatives(let rules):
            tokenizer = AlternativesTokenizer(
                rules: rules,
                tokenizerFactory: self
            )
        case .RuleReference(let ruleIdentifier):
            tokenizer = RuleReferenceTokenizer(
                ruleIdentifier: ruleIdentifier,
                tokenizerFactory: self
            )
        case .Terminal(let terminal):
            tokenizer = TerminalTokenizer(
                terminal: terminal
            )
        case .Lazy(let startRule, let rule, let stopRule):
            tokenizer = LazyTokenizer(
                startRule: startRule,
                rule: rule,
                stopRule: stopRule,
                tokenizerFactory: self
            )
        case .Eof:
            tokenizer = EofTokenizer()
        case .CustomTokenizer(let factory):
            tokenizer = factory.tokenizer(self)
        }
        
        return tokenizer
    }
}