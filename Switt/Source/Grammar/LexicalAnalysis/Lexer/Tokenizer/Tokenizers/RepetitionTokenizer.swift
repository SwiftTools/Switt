// 1 or more repetion
class RepetitionTokenizer: Tokenizer {
    private var tokenizer: Tokenizer
    private let rule: LexerRule
    private let tokenizerFactory: TokenizerFactory
    
    init(rule: LexerRule, tokenizerFactory: TokenizerFactory) {
        self.rule = rule
        self.tokenizerFactory = tokenizerFactory
        self.tokenizer = tokenizerFactory.tokenizer(rule)
    }
    
    func feed(char: Character) -> TokenizerState {
        switch tokenizer.feed(char) {
        case .Possible:
            return .Possible
        case .Fail:
            return .Fail
        case .Complete:
            tokenizer = tokenizerFactory.tokenizer(rule)
            return .Complete
        }
    }
}