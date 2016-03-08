//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionOperatorScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionOperatorDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionOperatorDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
