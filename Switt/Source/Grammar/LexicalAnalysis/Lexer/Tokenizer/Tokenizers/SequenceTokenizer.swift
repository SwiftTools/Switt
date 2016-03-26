class SequenceTokenizer: Tokenizer {
    private var ruleIndex: Int
    private let tokenizers: [Lazy<Tokenizer>]
    
    init(rules: [LexerRule], tokenizerFactory: TokenizerFactory) {
        ruleIndex = 0
        self.tokenizers = rules.map { Lazy(tokenizerFactory.tokenizer($0)) }
    }
    
    func feed(char: Character) -> TokenizerState {
        if let tokenizer = tokenizers.at(ruleIndex) {
            switch tokenizer.value.feed(char) {
            case .Possible:
                return .Possible
            case .Fail:
                return .Fail
            case .Complete:
                ruleIndex++
                if tokenizers.at(ruleIndex) == nil {
                    return .Complete
                } else {
                    return .Possible
                }
            }
        } else {
            return .Fail
        }
    }
}