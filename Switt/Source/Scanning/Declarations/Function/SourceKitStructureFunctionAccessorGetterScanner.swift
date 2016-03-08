//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionAccessorGetterScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionAccessorGetterDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionAccessorGetterDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
