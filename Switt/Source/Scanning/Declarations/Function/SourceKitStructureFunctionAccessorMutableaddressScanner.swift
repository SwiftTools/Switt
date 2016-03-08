//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionAccessorMutableaddressScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionAccessorMutableaddressDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionAccessorMutableaddressDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
