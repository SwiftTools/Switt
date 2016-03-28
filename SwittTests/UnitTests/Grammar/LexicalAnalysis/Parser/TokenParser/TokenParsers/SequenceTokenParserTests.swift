import Quick
import Nimble
@testable import Switt

private class Helper {
    static func parser(rules rules: [ParserRule]) -> TokenParser {
        let parser = SequenceTokenParser(
            rules: rules,
            tokenParserFactory: TokenParserFactoryImpl(
                parserRules: ParserRules()
            )
        )
        return parser
    }
}

class SequenceTokenParserTests: QuickSpec {
    override func spec() {
        describe("SequenceTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = Helper.parser(
                    rules: [
                        ParserRule.Terminal(terminal: "a"),
                        ParserRule.Terminal(terminal: "b")
                    ]
                )
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a", "b" ])
                let parser = Helper.parser(
                    rules: [
                        ParserRule.Terminal(terminal: "a"),
                        ParserRule.Terminal(terminal: "b")
                    ]
                )
                let result = parser.parse(stream)
                let tokenStrings = result?.map { $0.token?.string }
                
                expect(tokenStrings).to(equal(["a", "b"]))
                expect(stream.index).to(equal(2))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "x" ])
                let parser = Helper.parser(
                    rules: [
                        ParserRule.Terminal(terminal: "a")
                    ]
                )
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([])
                let parser = Helper.parser(
                    rules: [
                        ParserRule.Terminal(terminal: "a")
                    ]
                )
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
        }
    }
}