class EofTokenizer: Tokenizer {
    func feed(char: Character?) -> TokenizerState {
        if char == nil {
            return .Complete
        } else {
            return .Fail
        }
    }
}