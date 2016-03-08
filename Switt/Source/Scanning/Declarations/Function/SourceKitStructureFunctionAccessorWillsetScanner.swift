//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionAccessorWillsetScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionAccessorWillsetDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionAccessorWillsetDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
