//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SourceKitStructureVarStaticScanner: SourceKitStructureBaseScanner {
    func scanDeclaration() -> VarStaticDeclaration? {
        do {
            return VarStaticDeclaration(
                name: try name(),
                type: varType(),
                expression: try varExpression().unwrap(),
                accessibility: try accessibility()
            )
        } catch {
            return nil
        }
    }
}
