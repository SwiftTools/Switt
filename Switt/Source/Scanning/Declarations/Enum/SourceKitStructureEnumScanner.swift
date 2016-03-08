//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureEnumScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> EnumDeclaration? {
        do {
            resetExpectations()
            
            let declaration = EnumDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
