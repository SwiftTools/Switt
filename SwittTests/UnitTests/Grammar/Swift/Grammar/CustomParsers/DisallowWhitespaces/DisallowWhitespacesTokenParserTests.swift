import Quick
import Nimble
@testable import Switt

private struct TokenStreamAndExpectedIndex {
    var stream: TokenInputOutputStream
    var expectedEndIndex: Int
    
    init(_ stream: TokenInputOutputStream, expectedEndIndex: Int) {
        self.stream = stream
        self.expectedEndIndex = expectedEndIndex
    }
    
    init(_ tokens: [TokenConvertible], expectedEndIndex: Int) {
        self.init(TokenStreamHelper.tokenStream(tokens), expectedEndIndex: expectedEndIndex)
    }
}

class DisallowHiddenTokensTokenParserTests: QuickSpec {
    override func spec() {
        describe("") {
            var parser: DisallowHiddenTokensTokenParser!
            var result: [SyntaxTree]?
            
            beforeEach {
                parser = DisallowHiddenTokensTokenParser(
                    parserRule: ParserRule.Sequence(
                        rules: [
                            ParserRule.Terminal(terminal: "a"),
                            ParserRule.Terminal(terminal: "b")
                        ]
                    ),
                    tokenParserFactory: TokenParserFactoryImpl(parserRules: ParserRules())
                )
            }
            
            it("parses properly") {
                let validStreams: [TokenStreamAndExpectedIndex] = [
                    TokenStreamAndExpectedIndex([" ", "a", "b", " "], expectedEndIndex: 3),
                    TokenStreamAndExpectedIndex([" ", "a", "b"], expectedEndIndex: 3),
                    TokenStreamAndExpectedIndex(["a", "b", " "], expectedEndIndex: 2),
                    TokenStreamAndExpectedIndex(["a", "b"], expectedEndIndex: 2)
                ]
                
                for (i, validStream) in validStreams.enumerate() {
                    result = parser.parse(validStream.stream)
                    
                    expect(result).toNot(beNil(), description: "stream id: \(i)")
                    expect(validStream.stream.index).to(equal(validStream.expectedEndIndex))
                    expect(validStream.stream.index).to(equal(validStream.expectedEndIndex), description: "stream id: \(i)")
                }
            }
            
            it("fails to parse properly") {
                let invalidStreams: [TokenStreamAndExpectedIndex] = [
                    TokenStreamAndExpectedIndex([" ", "a", " ", "b", " "], expectedEndIndex: 0),
                    TokenStreamAndExpectedIndex([" ", "a", " ", "b"], expectedEndIndex: 0),
                    TokenStreamAndExpectedIndex(["a", " ", "b", " "], expectedEndIndex: 0),
                    TokenStreamAndExpectedIndex(["a", " ", "b"], expectedEndIndex: 0),
                    TokenStreamAndExpectedIndex([" ", "a", RuleName.Block_comment, "b", " "], expectedEndIndex: 0)
                ]
                
                for (i, invalidStream) in invalidStreams.enumerate() {
                    result = parser.parse(invalidStream.stream)
                    
                    expect(result).to(beNil(), description: "stream id: \(i)")
                    expect(invalidStream.stream.index).to(equal(invalidStream.expectedEndIndex), description: "stream id: \(i)")
                }
            }
        }
    }
}