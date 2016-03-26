class AlternativesTokenizer: Tokenizer {
    private var tokenizers: [Lazy<Tokenizer>]
    
    init(rules: [LexerRule], tokenizerFactory: TokenizerFactory) {
        self.tokenizers = rules.map { Lazy(tokenizerFactory.tokenizer($0)) }
    }
    
    func feed(char: Character) -> TokenizerState {
        var completeTokenizers: [Lazy<Tokenizer>] = []
        var possibleTokenizers: [Lazy<Tokenizer>] = []
        
        for tokenizer in tokenizers {
            switch tokenizer.value.feed(char) {
            case .Complete:
                completeTokenizers.append(tokenizer)
            case .Fail:
                break
            case .Possible:
                possibleTokenizers.append(tokenizer)
            }
        }
        
        tokenizers = completeTokenizers + possibleTokenizers
        
        if completeTokenizers.count > 0 {
            return .Complete
        } else if possibleTokenizers.count > 0 {
            return .Possible
        } else {
            return .Fail
        }
    }
}