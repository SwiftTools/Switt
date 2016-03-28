import Quick
import Nimble
@testable import Switt

class EmptyTokenParserTests: QuickSpec {
    override func spec() {
        describe("EmptyTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = EmptyTokenParser()
                let result = parser.parse(stream)
                
                expect(result).toNot(beNil())
                expect(stream.index).to(equal(0))
            }
            
            it("") {
                let stream = TokenStreamHelper.tokenStream([])
                let parser = EmptyTokenParser()
                let result = parser.parse(stream)
                
                expect(result).toNot(beNil())
                expect(stream.index).to(equal(0))
            }
        }
    }
}