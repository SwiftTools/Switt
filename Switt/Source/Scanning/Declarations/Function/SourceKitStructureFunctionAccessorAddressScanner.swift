//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionAccessorAddressScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionAccessorAddressDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionAccessorAddressDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
