class RuleReferenceTokenizer: Tokenizer {
    private let tokenizer: Tokenizer?
    
    init(ruleIdentifier: RuleIdentifier, tokenizerFactory: TokenizerFactory) {
        tokenizer = tokenizerFactory.tokenizer(ruleIdentifier)
    }
    
    func feed(char: Character?) -> TokenizerState {
        return tokenizer?.feed(char) ?? .Fail
    }
}