import Quick
import Nimble
@testable import Switt

class PrefixOperatorTokenParserTests: QuickSpec {
    override func spec() {
        describe("") {
            var parser: PrefixOperatorTokenParser!
            var result: [SyntaxTree]?
            
            beforeEach {
                parser = PrefixOperatorTokenParser(
                    operatorRule: ParserRule.Terminal(terminal: "+"),
                    tokenParserFactory: TokenParserFactoryImpl(parserRules: ParserRules())
                )
            }
            
            it("parses prefix operator if it has whitespaces on the left side only") {
                result = parser.parse(TokenStreamHelper.tokenStream([" ", "+", "a"]))
                
                expect(result).toNot(beNil())
                
                result = parser.parse(TokenStreamHelper.tokenStream([" ", "+", "a"], currentIndex: 1))
                
                expect(result).toNot(beNil())
                
                result = parser.parse(TokenStreamHelper.tokenStream([" ", " ", "+", "a"]))
                
                expect(result).toNot(beNil())
            }
            
            it("fails to prefix binary operator properly") {
                let invalidStreams: [TokenInputStream] = [
                    TokenStreamHelper.tokenStream(["a", "+", " "]),
                    TokenStreamHelper.tokenStream([" ", "-", "a"], currentIndex: 1),
                    TokenStreamHelper.tokenStream([" ", "+", " ", "a"]),
                    TokenStreamHelper.tokenStream([" ", RuleName.Block_comment, "+", "a"], currentIndex: 1)
                ]
                
                for (i, stream) in invalidStreams.enumerate() {
                    result = parser.parse(stream)
                    
                    expect(result).to(beNil(), description: "stream id: \(i)")
                }
            }
        }
    }
}