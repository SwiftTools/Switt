import Quick
import Nimble
@testable import Switt

class EofTokenParserTests: QuickSpec {
    override func spec() {
        describe("EofTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = EofTokenParser()
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([])
                let parser = EofTokenParser()
                let result = parser.parse(stream)
                
                expect(result).toNot(beNil())
                expect(stream.index).to(equal(0))
            }
        }
    }
}