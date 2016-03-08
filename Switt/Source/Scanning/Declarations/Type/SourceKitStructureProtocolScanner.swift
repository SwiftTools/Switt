//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureProtocolScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> ProtocolDeclaration? {
        do {
            resetExpectations()
            
            let declaration = ProtocolDeclaration(
                name: try name(),
                runtimeName: try runtimeName(),
                accessibility: try accessibility(),
                
                inits: inits(),
                deinits: deinits(),
                
                instanceMethods: instanceMethods(),
                classMethods: classMethods(),
                staticMethods: staticMethods(),
                
                typealiases: typealiases(),
                
                instanceVars: instanceVars()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
