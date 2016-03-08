//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureExtensionEnumScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ExtensionEnumDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ExtensionEnumDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
