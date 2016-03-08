//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionSubscriptScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionSubscriptDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionSubscriptDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
