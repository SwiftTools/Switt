//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureClassScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ClassDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ClassDeclaration(
                name: try name(),
                runtimeName: try runtimeName(),
                accessibility: try accessibility(),
            
                inits: inits(),
                deinits: deinits(),
            
                instanceMethods: instanceMethods(),
                classMethods: classMethods(),
                staticMethods: staticMethods(),
            
                nestedClasses: classes(),
                nestedStructs: structs(),
                nestedTypealiases: typealiases(),
                
                staticVars: staticVars(),
                instanceVars: instanceVars()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}