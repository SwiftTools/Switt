//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionMethodInstanceScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionMethodInstanceDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionMethodInstanceDeclaration(
                parameters: parameters(),
                genericPlaceholders: genericPlaceholders()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
