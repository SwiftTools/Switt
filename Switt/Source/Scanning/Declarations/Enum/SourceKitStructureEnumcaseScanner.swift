//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureEnumcaseScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> EnumcaseDeclaration? {
        do {
            resetExpectations()
            
            let declaration = EnumcaseDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
