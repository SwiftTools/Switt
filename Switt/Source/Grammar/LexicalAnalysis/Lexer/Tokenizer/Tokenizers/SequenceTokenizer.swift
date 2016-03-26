class SequenceTokenizer: Tokenizer {
    private var ruleIndex: Int
    private let tokenizers: [Lazy<Tokenizer>]
    private var wasComplete: Bool = false
    
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
                if wasComplete {
                    wasComplete = false
                    ruleIndex += 1
                    if let tokenizer = tokenizers.at(ruleIndex) {
                        switch tokenizer.value.feed(char) {
                        case .Possible:
                            return .Possible
                        case .Fail:
                            return .Fail
                        case .Complete:
                            wasComplete = true
                            if tokenizers.at(ruleIndex + 1) == nil {
                                return .Complete
                            } else {
                                return .Possible
                            }
                        }
                    } else {
                        // Sequence ended. New char is outside of sequence
                        return .Fail
                    }
                } else {
                    return .Fail
                }
            case .Complete:
                wasComplete = true
                if tokenizers.at(ruleIndex + 1) == nil {
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