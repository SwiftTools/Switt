import Quick
import Nimble
@testable import Switt

private class Helper {
    static func parse(terminal: String, stream: TokenInputStream) -> [SyntaxTree]? {
        let parser = TerminalTokenParser(terminal: terminal)
        return parser.parse(stream)
    }
}

class TerminalTokenParserTests: QuickSpec {
    override func spec() {
        describe("TerminalTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "abc" ])
                let parser = TerminalTokenParser(terminal: "abc")
                let result = parser.parse(stream)
                let tokenStrings = result?.map { $0.token?.string }
                
                expect(tokenStrings).to(equal(["abc"]))
                expect(stream.index).to(equal(1))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "xxx" ])
                let parser = TerminalTokenParser(terminal: "abc")
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "abc", "abc" ])
                let parser = TerminalTokenParser(terminal: "abc")
                let result = parser.parse(stream)
                let tokenStrings = result?.map { $0.token?.string }
                
                expect(tokenStrings).to(equal(["abc"]))
                expect(stream.index).to(equal(1))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([])
                let parser = TerminalTokenParser(terminal: "abc")
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
        }
    }
}