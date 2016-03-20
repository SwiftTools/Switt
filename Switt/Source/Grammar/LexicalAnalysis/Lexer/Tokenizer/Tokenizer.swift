protocol Tokenizer {
    func feed(char: Character) -> TokenizerState
}