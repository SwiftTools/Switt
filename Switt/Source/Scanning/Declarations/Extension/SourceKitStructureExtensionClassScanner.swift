//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureExtensionClassScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ExtensionClassDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ExtensionClassDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
