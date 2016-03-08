//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionDestructorScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionDestructorDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionDestructorDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}

