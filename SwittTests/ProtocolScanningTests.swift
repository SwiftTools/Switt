@testable import Switt
import Nimble
import XCTest

class ProtocolScanningTests: XCTestCase {
    func test() {
        let parser = SwiftFileParserImpl()
        let file = parser.parse(TestSwiftFile.file)
        
        print(file)
        
        expect(file).toNot(beNil())
    }
}
