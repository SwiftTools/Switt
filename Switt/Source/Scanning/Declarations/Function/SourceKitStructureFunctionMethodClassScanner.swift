//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionMethodClassScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionMethodClassDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionMethodClassDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
