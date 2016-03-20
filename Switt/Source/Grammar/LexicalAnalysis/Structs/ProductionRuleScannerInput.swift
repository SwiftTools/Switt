struct TokenSource {
    var stream: CharacterInputStream
    var startPosition: StreamPosition
    
    // including last symbol, e.g.: "01", start position = 0, end position = 1
    var endPosition: StreamPosition
}

struct Token {
    var source: TokenSource
    var string: String
    var name: RuleName
}

struct ProductionRuleScannerInput {
    var inputStream: CharacterInputStream
    var grammar: Grammar
    var ruleContext: RuleContext
    var rulesThatCanCauseRecursion: Set<RuleName>
    var tokens: [Token]
}