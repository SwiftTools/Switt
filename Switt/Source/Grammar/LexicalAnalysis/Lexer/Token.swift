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

extension Token {
    var previousToken: Token? {
        return source.stream.tokenAt(-1, position: source.position)
    }
    
    var nextToken: Token? {
        return source.stream.tokenAt(1, position: source.position)
    }
}