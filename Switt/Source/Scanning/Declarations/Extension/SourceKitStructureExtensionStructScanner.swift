//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureExtensionStructScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ExtensionStructDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ExtensionStructDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
