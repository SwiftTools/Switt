class RuleReferenceTokenizer: Tokenizer {
    private let tokenizer: Tokenizer?
    
    init(ruleName: RuleName, tokenizerFactory: TokenizerFactory) {
        tokenizer = tokenizerFactory.tokenizer(ruleName)
    }
    
    func feed(char: Character) -> TokenizerState {
        return tokenizer?.feed(char) ?? .Fail
    }
}