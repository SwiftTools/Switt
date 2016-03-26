class CharTokenizer: Tokenizer {
    private let charRanges: [CharRange]
    private let resultIfContains: Bool
    private var alreadyFed: Bool = false
    
    init(charRanges: [CharRange], invert: Bool) {
        self.charRanges = charRanges
        
        if invert {
            // No character from charRanges should match.
            // So if at least 1 character is matching some range,
            // matches() returns false
            self.resultIfContains = false
        } else {
            // At least one range should contain character.
            // So if at least 1 character is matching some range,
            // matches() returns false
            self.resultIfContains = true
        }
    }
    
    func feed(char: Character) -> TokenizerState {
        if alreadyFed {
            return .Fail
        } else {
            alreadyFed = true
            if matches(char) {
                return .Complete
            } else {
                return .Fail
            }
        }
    }
    
    private func matches(char: Character) -> Bool {
        for range in charRanges {
            let contains = range.contains(char)
            if contains {
                return resultIfContains
            }
        }
        let resultIfNotContains = !resultIfContains
        return resultIfNotContains
    }
}