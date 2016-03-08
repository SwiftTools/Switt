//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureExtensionProtocolScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ExtensionProtocolDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ExtensionProtocolDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
