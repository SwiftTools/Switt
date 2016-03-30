import Quick
import Nimble
@testable import Switt

class PostfixOperatorTokenParserTests: QuickSpec {
    override func spec() {
        describe("") {
            var parser: PostfixOperatorTokenParser!
            var result: [SyntaxTree]?
            
            beforeEach {
                parser = PostfixOperatorTokenParser(
                    operatorRule: ParserRule.Terminal(terminal: "+"),
                    tokenParserFactory: TokenParserFactoryImpl(parserRules: ParserRules())
                )
            }
            
            it("parses postfix operator if it has whitespaces on the right side only") {
                result = parser.parse(TokenStreamHelper.tokenStream(["a", "+", " "], currentIndex: 1))
                
                expect(result).toNot(beNil())
            }
            
            it("parses postfix operator if it has no whitespace on the left but is followed immediately by a dot") {
                result = parser.parse(TokenStreamHelper.tokenStream(["a", "+", RuleName.DOT, "b"], currentIndex: 1))
                
                expect(result).toNot(beNil())
            }
            
            it("fails to parse postfix operator properly") {
                let invalidStreams: [TokenInputStream] = [
                    TokenStreamHelper.tokenStream([" ", "+", "a"]),
                    TokenStreamHelper.tokenStream(["a", "-", " "], currentIndex: 1),
                    TokenStreamHelper.tokenStream([" ", "+", " ", "a"]),
                    TokenStreamHelper.tokenStream([" ", " ", "+", "a"]),
                    TokenStreamHelper.tokenStream(["a", "+", RuleName.Line_comment], currentIndex: 1)
                ]
                
                for (i, stream) in invalidStreams.enumerate() {
                    result = parser.parse(stream)
                    
                    expect(result).to(beNil(), description: "stream id: \(i)")
                }
            }
        }
    }
}