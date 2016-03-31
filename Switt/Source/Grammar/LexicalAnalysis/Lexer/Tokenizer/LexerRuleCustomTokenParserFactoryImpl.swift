class LexerRuleCustomTokenParserFactoryImpl: LexerRuleCustomTokenParserFactory {
    private let customTokenizerFactory: CustomTokenizerFactory
    private let lexerRuleConverter: LexerRuleConverter
    
    init(customTokenizerFactory: CustomTokenizerFactory, lexerRuleConverter: LexerRuleConverter) {
        self.customTokenizerFactory = customTokenizerFactory
        self.lexerRuleConverter = lexerRuleConverter
    }
    
    func tokenizer(tokenizerFactory: TokenizerFactory) -> Tokenizer {
        return customTokenizerFactory.tokenizer(
            tokenizerFactory: tokenizerFactory,
            lexerRuleConverter: lexerRuleConverter
        )
    }
}
