//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureVarParameterScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> VarParameterDeclaration? {
        do {
            resetExpectations()
            
            let declaration = VarParameterDeclaration(
                name: try name(),
                varType: varType()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
