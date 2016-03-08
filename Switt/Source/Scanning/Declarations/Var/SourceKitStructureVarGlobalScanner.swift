//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureVarGlobalScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> VarGlobalDeclaration? {
        do {
            resetExpectations()
            
            let declaration = VarGlobalDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
