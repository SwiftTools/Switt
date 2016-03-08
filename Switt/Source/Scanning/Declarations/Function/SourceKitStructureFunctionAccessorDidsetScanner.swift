//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionAccessorDidsetScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionAccessorDidsetDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionAccessorDidsetDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
