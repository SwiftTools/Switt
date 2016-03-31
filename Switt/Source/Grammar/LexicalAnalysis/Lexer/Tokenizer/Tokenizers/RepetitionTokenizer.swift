// 1 or more repetion
class RepetitionTokenizer: Tokenizer {
    private var tokenizer: Tokenizer
    private let rule: LexerRule
    private let tokenizerFactory: TokenizerFactory
    private var wasComplete: Bool = false
    
    init(rule: LexerRule, tokenizerFactory: TokenizerFactory) {
        self.rule = rule
        self.tokenizerFactory = tokenizerFactory
        self.tokenizer = tokenizerFactory.tokenizer(rule)
    }
    
    func feed(char: Character?) -> TokenizerState {
        switch tokenizer.feed(char) {
        case .Possible:
            wasComplete = false
            return .Possible
        case .Fail:
            if wasComplete {
                wasComplete = false
                
                // Retry from beginning
                tokenizer = tokenizerFactory.tokenizer(rule)
                
                switch tokenizer.feed(char) {
                case .Possible:
                    return .Possible
                case .Fail:
                    return .Fail
                case .Complete:
                    wasComplete = true
                    return .Complete
                case .FatalError:
                    return .FatalError
                }
            } else {
                return .Fail
            }
        case .Complete:
            wasComplete = true
            return .Complete
        case .FatalError:
            return .FatalError
        }
    }
}