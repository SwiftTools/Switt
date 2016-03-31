protocol LexerRuleCustomTokenParserFactory {
    func tokenizer(tokenierFactory: TokenizerFactory) -> Tokenizer
}