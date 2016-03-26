class TerminalTokenizer: Tokenizer {
    private let terminal: String
    private var index: String.Index
    
    init(terminal: String) {
        self.terminal = terminal
        self.index = terminal.startIndex
    }
    
    func feed(char: Character) -> TokenizerState {
        let currentChar = terminal.characters.at(index)
        
        if index < terminal.endIndex {
            index = index.advancedBy(1)
        }
        
        if currentChar == char {
            if index == terminal.endIndex {
                return .Complete
            } else {
                return .Possible
            }
        } else {
            return .Fail
        }
    }
}