//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureVarLocalScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> VarLocalDeclaration? {
        do {
            resetExpectations()
            
            let declaration = VarLocalDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
