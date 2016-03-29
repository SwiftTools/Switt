class SequenceTokenParser: TokenParser {
    private let rules: [ParserRule]
    private let tokenParserFactory: TokenParserFactory
    
    init(rules: [ParserRule], tokenParserFactory: TokenParserFactory) {
        self.rules = rules
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let parsers = rules.map { tokenParserFactory.tokenParser($0) }
        let position = inputStream.position
        
        var nodes: [SyntaxTree] = []
        
        for parser in parsers {
            if let subnodes = parser.parse(inputStream) {
                nodes.appendContentsOf(subnodes)
            } else {
                position.restore()
                return SyntaxTree.fail()
            }
        }
        
        return nodes
    }
}