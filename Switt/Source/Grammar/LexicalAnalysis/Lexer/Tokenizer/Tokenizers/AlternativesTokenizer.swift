class AlternativesTokenizer: Tokenizer {
    private var tokenizers: [Tokenizer]
    
    init(rules: [LexerRule], tokenizerFactory: TokenizerFactory) {
        self.tokenizers = rules.map(tokenizerFactory.tokenizer)
    }
    
    func feed(char: Character) -> TokenizerState {
        var completeTokenizers: [Tokenizer] = []
        var possibleTokenizers: [Tokenizer] = []
        
        for tokenizer in tokenizers {
            switch tokenizer.feed(char) {
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