import Quick
import Nimble
@testable import Switt

class BinaryOperatorTokenParserTests: QuickSpec {
    override func spec() {
        describe("") {
            var parser: BinaryOperatorTokenParser!
            var result: [SyntaxTree]?
            
            beforeEach {
                parser = BinaryOperatorTokenParser(
                    operatorRule: ParserRule.Terminal(terminal: "+"),
                    tokenParserFactory: TokenParserFactoryImpl(parserRules: ParserRules())
                )
            }
            
            it("parses binary operator if it has whitespaces on both sides") {
                result = parser.parse(TokenStreamHelper.tokenStream([" ", "+", " "]))
                
                expect(result).toNot(beNil())
            }
            
            it("parses binary operator if it has whitespaces on neither side") {
                result = parser.parse(TokenStreamHelper.tokenStream(["a", "+", "b"], currentIndex: 1))
                
                expect(result).toNot(beNil())
            }
            
            it("fails to parse binary operator if it has whitespace only on one side") {
                result = parser.parse(TokenStreamHelper.tokenStream(["a", "+", " "], currentIndex: 1))
                
                expect(result).to(beNil())
                
                result = parser.parse(TokenStreamHelper.tokenStream([" ", "+", "a"]))
                
                expect(result).to(beNil())
            }
            
            it("fails to parse different operator than passed in constructor") {
                result = parser.parse(TokenStreamHelper.tokenStream([" ", "-", " "]))
                
                expect(result).to(beNil())
            }
            
            it("parses binary operator successfully if there are more than 1 whitespaces on sides") {
                result = parser.parse(TokenStreamHelper.tokenStream([" ", " ", "+", " ", " "]))
                
                expect(result).toNot(beNil())
                
                result = parser.parse(TokenStreamHelper.tokenStream([" ", " ", "+", " "]))
                
                expect(result).toNot(beNil())
                
                result = parser.parse(TokenStreamHelper.tokenStream([" ", "+", " ", " "]))
                
                expect(result).toNot(beNil())
            }
            
            it("take comments into account") {
                let validStreams: [[TokenConvertible]] = [
                    [RuleName.Line_comment, " ", "+", " "],
                    [" ", RuleName.Line_comment, " ", "+", " "],
                    
                    [" ", "+", " ", RuleName.Line_comment],
                    [" ", "+", " ", RuleName.Line_comment, " "],
                    
                    [" ", RuleName.Line_comment, " ", "+", " ", RuleName.Line_comment, " "],
                    
                    // Has no whitespaces on left and right
                    [" ", RuleName.Line_comment, "+", RuleName.Line_comment, " "],
                    [" ", RuleName.Block_comment, "+", RuleName.Block_comment, " "]
                ]
                
                let invalidStreams: [[TokenConvertible]] = [
                    [" ", RuleName.Line_comment, "+", " "],
                    [" ", "+", RuleName.Line_comment, " "],
                    [" ", RuleName.Line_comment, "+", " ", RuleName.Line_comment],
                    [RuleName.Line_comment, " ", "+", RuleName.Line_comment, " "],
                ]
                
                for (i, stream) in validStreams.enumerate() {
                    result = parser.parse(TokenStreamHelper.tokenStream(stream))
                    
                    expect(result).toNot(beNil(), description: "stream id: \(i)")
                }
                
                for (i, stream) in invalidStreams.enumerate() {
                    result = parser.parse(TokenStreamHelper.tokenStream(stream))
                    
                    expect(result).to(beNil(), description: "stream id: \(i)")
                }
            }
        }
    }
}