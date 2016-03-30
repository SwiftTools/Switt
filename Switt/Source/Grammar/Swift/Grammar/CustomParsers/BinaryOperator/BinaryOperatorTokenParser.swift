// From docs:
// https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID410
//
// If an operator has whitespace around both sides or around neither side,
// it is treated as a binary operator.
// As an example, the +++ operator in a+++b and a +++ b is treated as a binary operator.

class BinaryOperatorTokenParser: TokenParser {
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
            
            let isBinaryOperator = (hasWhitespaceBefore && hasWhitespaceAfter) || (!hasWhitespaceBefore && !hasWhitespaceAfter)
            
            if isBinaryOperator {
                return result
            }
                
        }
        
        // Fail:
        position.restore()
        return nil
    }
}