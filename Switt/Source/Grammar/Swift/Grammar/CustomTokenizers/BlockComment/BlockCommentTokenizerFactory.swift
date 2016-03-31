class BlockCommentTokenizerFactory: CustomTokenizerFactory {
    var involvedTerminals: [String] {
        return []
    }
    
    func tokenizer(tokenizerFactory tokenizerFactory: TokenizerFactory, lexerRuleConverter parserRuleConverter: LexerRuleConverter) -> Tokenizer {
        return BlockCommentTokenizer()
    }
}