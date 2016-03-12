//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

class VarScanner {
    private let dependencies: SourceKitStructureScanningDependencies
    private let codeScanner: SourceKitStructureCodeScanner
    
    init(dependencies: SourceKitStructureScanningDependencies) {
        self.dependencies = dependencies
        
        codeScanner = SourceKitStructureCodeScanner(
            sourceKitStructure: dependencies.sourceKitStructure,
            file: dependencies.file
        )
    }
    
    func type() -> String? {
        if let typeName = dependencies.sourceKitStructure.typename {
            if let name = dependencies.sourceKitStructure.name {
                if typeName == name {
                    return nil
                } else {
                    return typeName
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func expression() -> String? {
//        if let code = codeScanner.scanCode() {
//            let info = VarTypeInferenceInfo(
//                declarationCode: declarationCode,
//                declarationPath: dependencies.declarationPath
//            )
//            
//            return VarType.Inferred(info)
//        } else {
//            dependencies.logger.logVarTypeInferenceError(VarTypeInferenceError.NoDeclarationCode)
//        }
        
        return nil
    }
}