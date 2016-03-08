//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureStructScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> StructDeclaration? {
        do {
            let declaration = StructDeclaration(
                name: try name(),
                runtimeName: try runtimeName(),
                accessibility: try accessibility(),
                
                inits: inits(),
                deinits: deinits(),
                
                instanceMethods: instanceMethods(),
                staticMethods: staticMethods(),
                
                nestedClasses: classes(),
                nestedStructs: structs(),
                nestedTypealiases: typealiases()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
