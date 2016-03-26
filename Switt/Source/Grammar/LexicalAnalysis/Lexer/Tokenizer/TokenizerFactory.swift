protocol TokenizerFactory {
    func tokenizer(ruleName: RuleName) -> Tokenizer?
    func tokenizer(lexerRule: LexerRule) -> Tokenizer
}