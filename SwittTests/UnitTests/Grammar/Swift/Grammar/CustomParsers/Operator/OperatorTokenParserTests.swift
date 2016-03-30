import Quick
import Nimble
@testable import Switt

class OperatorTokenParserTests: QuickSpec {
    override func spec() {
        describe("") {
            var parser: OperatorTokenParser!
            var result: [SyntaxTree]?
            
            beforeEach {
                parser = OperatorTokenParser(
                    operatorName: "++",
                    tokenParserFactory: TokenParserFactoryImpl(parserRules: ParserRules())
                )
            }
            
            it("parses operator") {
                let validStreams: [TokenInputStream] = [
                    TokenStreamHelper.tokenStream([" ", "+", "+", " "]),
                    TokenStreamHelper.tokenStream([" ", "+", "+"]),
                    TokenStreamHelper.tokenStream(["+", "+", " "]),
                    TokenStreamHelper.tokenStream(["+", "+"])
                ]
                
                for (i, stream) in validStreams.enumerate() {
                    result = parser.parse(stream)
                    
                    expect(result).toNot(beNil(), description: "stream id: \(i)")
                }
            }
            
            it("fails to parse operator properly") {
                let invalidStreams: [TokenInputStream] = [
                    TokenStreamHelper.tokenStream([" ", "+", " ", "+", " "]),
                    TokenStreamHelper.tokenStream([" ", "+", " ", "+"]),
                    TokenStreamHelper.tokenStream(["+", " ", "+", " "]),
                    TokenStreamHelper.tokenStream(["+", " ", "+"]),
                    TokenStreamHelper.tokenStream([" ", "+", RuleName.Block_comment, "+", " "])
                ]
                
                for (i, stream) in invalidStreams.enumerate() {
                    result = parser.parse(stream)
                    
                    expect(result).to(beNil(), description: "stream id: \(i)")
                }
            }
        }
    }
}