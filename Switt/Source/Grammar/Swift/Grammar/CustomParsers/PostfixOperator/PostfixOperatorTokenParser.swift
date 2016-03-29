// From docs:
// https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID410
//
// If an operator has whitespace on the right side only,
// it is treated as a postfix unary operator.
// As an example, the +++ operator in a+++ b is treated as a postfix unary operator.
//
// If an operator has no whitespace on the left but is followed immediately by a dot (.),
// it is treated as a postfix unary operator.
// As an example, the +++ operator in a+++.b is treated as a postfix unary operator (a+++ .b rather than a +++ .b).

class PostfixOperatorTokenParser: TokenParser {
    private let operatorRule: ParserRule
    private let tokenParserFactory: TokenParserFactory
    
    init(operatorRule: ParserRule, tokenParserFactory: TokenParserFactory) {
        self.operatorRule = operatorRule
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        let hasWhitespaceBefore = inputStream.token()?.ruleIdentifier == RuleIdentifier.Named(.WS)
        
        if !hasWhitespaceBefore {
            let parser = tokenParserFactory.tokenParser(operatorRule)
            
            if let result = parser.parse(inputStream) {
                let hasWhitespaceAfter = inputStream.token()?.ruleIdentifier == RuleIdentifier.Named(.WS)
                let hasDotAfter = inputStream.token()?.ruleIdentifier == RuleIdentifier.Named(.DOT)
                
                let isPostfixOperator = (hasWhitespaceAfter || hasDotAfter)
                
                if isPostfixOperator {
                    return result
                }
            }
        }
        
        // Fail:
        position.restore()
        return nil
    }
}