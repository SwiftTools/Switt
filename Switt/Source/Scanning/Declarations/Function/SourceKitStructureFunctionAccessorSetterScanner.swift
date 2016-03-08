//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionAccessorSetterScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionAccessorSetterDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionAccessorSetterDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
