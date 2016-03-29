struct Token {
    var string: String
    var ruleIdentifier: RuleIdentifier
    var channel: TokenChannel
    var source: TokenSource
}

struct TokenSource {
    var stream: TokenInputStream
    var position: StreamPosition
}