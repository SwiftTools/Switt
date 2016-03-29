class AlternativesTokenParser: TokenParser {
    private let rules: [ParserRule]
    private let tokenParserFactory: TokenParserFactory
    
    init(rules: [ParserRule], tokenParserFactory: TokenParserFactory) {
        self.rules = rules
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        struct BestResult {
            var position: StreamPosition
            var result: [SyntaxTree]?
        }
        
        var bestResult: BestResult?
        
        for rule in rules {
            let parser = tokenParserFactory.tokenParser(rule)
            
            if let result = parser.parse(inputStream) {
                if let bestPosition = bestResult?.position {
                    // Longer strings are preferred.
                    // If multiple parsers gave results, first is used.
                    if bestPosition < inputStream.position {
                        bestResult = BestResult(
                            position: inputStream.position,
                            result: result
                        )
                    }
                } else {
                    bestResult = BestResult(
                        position: inputStream.position,
                        result: result
                    )
                }
            }
            
            position.restore()
        }
        
        if let bestResult = bestResult {
            bestResult.position.restore()
            return bestResult.result
        } else {
            position.restore()
            return SyntaxTree.fail()
        }
    }
}