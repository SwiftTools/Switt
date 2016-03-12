//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import Switt
import XCTest

class SourceKitStructureScanningLoggerMock: SourceKitStructureScanningLogger {
    func logUnexpectedDeclaration(declaration: Declaration, inScanner scanner: AnyObject) {
        // Temp, helps to develop this project at this stage
        XCTFail("unexpected declaration: \(declaration), scanner: \(scanner)")
    }
}