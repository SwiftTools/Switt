import Quick
import Nimble
@testable import Switt

private class Helper {
    static func parser(rule: ParserRule) -> TokenParser {
        let parser = OptionalTokenParser(
            rule: rule,
            tokenParserFactory: TokenParserFactoryImpl(
                parserRules: ParserRules()
            )
        )
        return parser
    }
}

class OptionalTokenParserTests: QuickSpec {
    override func spec() {
        describe("OptionalTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = Helper.parser(ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                let tokenStrings = result?.map { tree in tree.token?.string }
                
                expect(tokenStrings).to(equal(["a"]))
                expect(stream.index).to(equal(1))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "b" ])
                let parser = Helper.parser(ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                
                expect(result).toNot(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([])
                let parser = Helper.parser(ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                
                expect(result).toNot(beNil())
                expect(stream.index).to(equal(0))
            }
        }
    }
}