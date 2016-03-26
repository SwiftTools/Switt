class TokenizerFactoryImpl: TokenizerFactory {
    private let lexerRules: LexerRules
    
    init(lexerRules: LexerRules) {
        self.lexerRules = lexerRules
    }
    
    func tokenizer(ruleName: RuleName) -> Tokenizer? {
        let rule: LexerRule? = lexerRules.rulesByName[ruleName] ?? lexerRules.fragmentsByName[ruleName]
        return rule.flatMap(tokenizer)
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
        case .RuleReference(let ruleName):
            tokenizer = RuleReferenceTokenizer(
                ruleName: ruleName,
                tokenizerFactory: self
            )
        case .Terminal(let terminal):
            tokenizer = TerminalTokenizer(
                terminal: terminal
            )
        case .Lazy(let rule, let stopRule, let stopRuleIsRequired):
            tokenizer = LazyTokenizer(
                rule: rule,
                stopRule: stopRule,
                stopRuleIsRequired: stopRuleIsRequired,
                tokenizerFactory: self
            )
        }
        
        return tokenizer
    }
}