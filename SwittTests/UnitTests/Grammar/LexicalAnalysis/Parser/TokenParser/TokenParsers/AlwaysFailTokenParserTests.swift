import Quick
import Nimble
@testable import Switt

class AlwaysFailTokenParserTests: QuickSpec {
    override func spec() {
        describe("AlwaysFailTokenParser") {
            it("") {
                let stream = TokenStreamHelper.tokenStream([ "a" ])
                let parser = AlwaysFailTokenParser()
                let result = parser.parse(stream)
                
                expect(result).to(beNil())
                expect(stream.index).to(equal(0))
            }
        }
    }
}