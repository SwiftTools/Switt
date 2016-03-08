//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionConstructorScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionConstructorDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionConstructorDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
