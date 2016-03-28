protocol TokenizerFactory {
    func tokenizer(ruleIdentifier: RuleIdentifier) -> Tokenizer?
    func tokenizer(lexerRule: LexerRule) -> Tokenizer
}