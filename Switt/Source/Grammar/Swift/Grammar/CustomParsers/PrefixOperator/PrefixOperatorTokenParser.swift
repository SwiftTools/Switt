// From docs:
// https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID410
//
// If an operator has whitespace on the left side only,
// it is treated as a prefix unary operator.
// As an example, the +++ operator in a +++b is treated as a prefix unary operator.

class PrefixOperatorTokenParser: TokenParser {
    private let operatorRule: ParserRule
    private let tokenParserFactory: TokenParserFactory
    
    init(operatorRule: ParserRule, tokenParserFactory: TokenParserFactory) {
        self.operatorRule = operatorRule
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        let parser = tokenParserFactory.tokenParser(operatorRule)
        
        if let result = parser.parse(inputStream),
            let previousToken = SyntaxTree.leftmostToken(result)?.previousToken,
            let nextToken = SyntaxTree.rightmostToken(result)?.nextToken
        {
            let hasWhitespaceBefore = previousToken.ruleIdentifier == RuleIdentifier.Named(.WS)
            let hasWhitespaceAfter = nextToken.ruleIdentifier == RuleIdentifier.Named(.WS)
            
            let isPrefixOperator = hasWhitespaceBefore && !hasWhitespaceAfter
            
            if isPrefixOperator {
                return result
            }
        }
        
        // Fail:
        position.restore()
        return nil
    }
}