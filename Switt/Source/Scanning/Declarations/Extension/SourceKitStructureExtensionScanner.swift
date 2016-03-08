//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureExtensionScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ExtensionDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ExtensionDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
