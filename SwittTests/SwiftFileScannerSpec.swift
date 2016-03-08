//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import Quick
import Nimble
@testable import Switt
import SwiftFelisCatus

class SwiftFileScannerSpec: QuickSpec {
    override func spec() {
        describe("SwiftFileScanner") {
            var swiftFileScanner: SwiftFileScanner!
            
            beforeEach {
                swiftFileScanner = SwiftFileScanner(
                    path: TestSwiftFile.file,
                    logger: SourceKitStructureScanningLoggerMock(),
                    reader: SourceKitFileReader()
                )
            }
            
            it("scans swift files and provide declarations") {
                let declarations = swiftFileScanner.scanDeclarations()
                
                expect(declarations.classes.count).to(equal(1))
            }
        }
    }
}
