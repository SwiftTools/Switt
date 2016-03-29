// TODO: make more generic: inject .WS rule identifier
// Same for other custom parsers

class DisallowWhitespacesTokenParser: TokenParser {
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
            let endPosition = inputStream.position
            
            startPosition.restore()
            
            var position = startPosition
            while (position < endPosition) {
                if inputStream.token()?.ruleIdentifier == RuleIdentifier.Named(.WS) {
                    startPosition.restore()
                    return nil
                }
                inputStream.moveNext()
                position = inputStream.position
            }
            
            return result
        } else {
            startPosition.restore()
            return nil
        }
    }
}