//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureTypealiasScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> TypealiasDeclaration? {
        do {
            resetExpectations()
            
            let declaration = TypealiasDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
