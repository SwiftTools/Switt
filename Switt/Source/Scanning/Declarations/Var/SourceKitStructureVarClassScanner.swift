//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureVarClassScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> VarClassDeclaration? {
        do {
            resetExpectations()
            
            let declaration = VarClassDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
