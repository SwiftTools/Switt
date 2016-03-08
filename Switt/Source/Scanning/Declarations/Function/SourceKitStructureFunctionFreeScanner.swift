//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionFreeScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionFreeDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionFreeDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
