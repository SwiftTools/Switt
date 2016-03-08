//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureEnumelementScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> EnumelementDeclaration? {
        do {
            resetExpectations()
            
            let declaration = EnumelementDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
