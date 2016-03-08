//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionMethodStaticScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionMethodStaticDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionMethodStaticDeclaration(
                parameters: parameters()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
