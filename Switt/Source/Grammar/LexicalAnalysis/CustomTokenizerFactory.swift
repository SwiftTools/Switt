protocol CustomTokenizerFactory: class {
    var involvedTerminals: [String] { get }
    
    func tokenizer(tokenizerFactory tokenizerFactory: TokenizerFactory, lexerRuleConverter: LexerRuleConverter) -> Tokenizer
}