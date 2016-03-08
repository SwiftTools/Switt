//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureModuleScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ModuleDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ModuleDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
