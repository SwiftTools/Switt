//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureVarInstanceScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> VarInstanceDeclaration? {
        do {
            resetExpectations()
            
            let declaration = VarInstanceDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
