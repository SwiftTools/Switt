//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureFunctionMethodInstanceScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> FunctionMethodInstanceDeclaration? {
        do {
            resetExpectations()
            
            let declaration = FunctionMethodInstanceDeclaration(
                name: try functionName(),
                nameAndArguments: try functionNameAndArguments(),
                accessibility: try accessibility(),
                parameters: parameters(),
                returnType: try functionReturnType(),
                genericPlaceholders: genericPlaceholders()
            )
            
            logUnexpectedDeclarations()
            
            return declaration
        } catch {
            return nil
        }
    }
}
