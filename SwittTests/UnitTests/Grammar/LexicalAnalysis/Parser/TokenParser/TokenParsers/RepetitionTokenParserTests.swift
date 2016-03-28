import Quick
import Nimble
@testable import Switt

private class Helper {
    static func parser(atLeast atLeast: UInt, _ rule: ParserRule) -> TokenParser {
        let parser = RepetitionTokenParser(
            rule: rule,
            atLeast: atLeast,
            tokenParserFactory: TokenParserFactoryImpl(
                parserRules: ParserRules()
            )
        )
        return parser
    }
}

class RepetitionTokenParserTests: QuickSpec {
    override func spec() {
        describe("RepetitionTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = Helper.parser(atLeast: 1, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                let nodes = result?.map { $0.token?.string }
                
                expect(nodes).to(equal(["a"]))
                expect(stream.index).to(equal(1))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = Helper.parser(atLeast: 2, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "b" ])
                let parser = Helper.parser(atLeast: 1, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "b" ])
                let parser = Helper.parser(atLeast: 0, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                let nodes = result?.map { $0.token?.string }
                
                expect(nodes).to(equal([]))
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a", "a" ])
                let parser = Helper.parser(atLeast: 1, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                let nodes = result?.map { $0.token?.string }
                
                expect(nodes).to(equal(["a", "a"]))
                expect(stream.index).to(equal(2))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a", "a" ])
                let parser = Helper.parser(atLeast: 0, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                let nodes = result?.map { $0.token?.string }
                
                expect(nodes).to(equal(["a", "a"]))
                expect(stream.index).to(equal(2))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a", "a", "a" ])
                let parser = Helper.parser(atLeast: 3, ParserRule.Terminal(terminal: "a"))
                let result = parser.parse(stream)
                let nodes = result?.map { $0.token?.string }
                
                expect(nodes).to(equal(["a", "a", "a"]))
                expect(stream.index).to(equal(3))
            }
        }
    }
}