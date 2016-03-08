//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureGenericTypeParamScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> GenericTypeParamDeclaration? {
        do {
            resetExpectations()
            
            let declaration = GenericTypeParamDeclaration()
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
