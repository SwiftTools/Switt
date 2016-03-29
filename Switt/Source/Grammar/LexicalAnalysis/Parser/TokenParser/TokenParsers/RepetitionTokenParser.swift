class RepetitionTokenParser: TokenParser {
    private let rule: ParserRule
    private let atLeast: UInt
    private let tokenParserFactory: TokenParserFactory
    
    init(rule: ParserRule, atLeast: UInt, tokenParserFactory: TokenParserFactory) {
        self.rule = rule
        self.atLeast = atLeast
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        var nodes: [SyntaxTree] = []

        for _ in 0..<atLeast {
            if let subnodes = parseOnce(inputStream) {
                nodes.appendContentsOf(subnodes)
            } else {
                position.restore()
                return SyntaxTree.fail()
            }
        }

        while true {
            let position = inputStream.position

            if let subnodes = parseOnce(inputStream) {
                nodes.appendContentsOf(subnodes)
            } else {
                position.restore()
                break
            }
        }
        
        return nodes
    }
    
    private func parseOnce(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let parser = tokenParserFactory.tokenParser(rule)
        return parser.parse(inputStream)
    }
}