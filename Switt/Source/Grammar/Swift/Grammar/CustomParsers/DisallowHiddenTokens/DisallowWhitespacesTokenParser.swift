// TODO: make more generic: inject .WS rule identifier
// Same for other custom parsers

class DisallowHiddenTokensTokenParser: TokenParser {
    private let parserRule: ParserRule
    private let tokenParserFactory: TokenParserFactory
    
    init(parserRule: ParserRule, tokenParserFactory: TokenParserFactory) {
        self.parserRule = parserRule
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let startPosition = inputStream.position
        
        let parser = tokenParserFactory.tokenParser(parserRule)
        
        if let result = parser.parse(inputStream) {
            let leftmostToken = SyntaxTree.leftmostToken(result)
            let rightmostToken = SyntaxTree.rightmostToken(result)
            
            let endPosition = inputStream.position
            
            if leftmostToken == nil && rightmostToken == nil {
                // No tokens - no hidden tokens
                return result
            } else {
                let checkedSequenceStartPosition = leftmostToken?.source.position ?? startPosition
                let checkedSequenceEndPosition = rightmostToken?.source.position ?? endPosition
                
                var position = checkedSequenceStartPosition
                checkedSequenceStartPosition.restore()
                
                while (position < checkedSequenceEndPosition) {
                    if inputStream.token()?.channel == .Hidden {
                        startPosition.restore()
                        return nil
                    }
                    inputStream.moveNext()
                    position = inputStream.position
                }
            }
            
            endPosition.restore()
            
            return result
        } else {
            startPosition.restore()
            return nil
        }
    }
}