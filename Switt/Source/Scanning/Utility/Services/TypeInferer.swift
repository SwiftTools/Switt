//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

class TypeInferer {
    private let dependencies: SourceKitStructureScanningDependencies
    private let codeScanner: SourceKitStructureCodeScanner
    
    init(dependencies: SourceKitStructureScanningDependencies) {
        self.dependencies = dependencies
        
        codeScanner = SourceKitStructureCodeScanner(
            sourceKitStructure: dependencies.sourceKitStructure,
            file: dependencies.file
        )
    }
    
    func varType() -> VarType {
        var errors = [VarTypeInferenceError]()
        
        if let typeName = dependencies.sourceKitStructure.typename {
            if let name = dependencies.sourceKitStructure.name {
                if typeName == name {
                    return inferredVarType()
                } else {
                    return strictVarType(typeName: typeName)
                }
            } else {
                errors.append(VarTypeInferenceError.NoName)
            }
        } else {
            errors.append(VarTypeInferenceError.NoTypeName)
        }
        
        return VarType.Unknown(errors)
    }
    
    private func inferredVarType() -> VarType {
        var errors = [VarTypeInferenceError]()
        
        if let declarationCode = codeScanner.scanCode() {
            let info = VarTypeInferenceInfo(
                declarationCode: declarationCode,
                declarationPath: dependencies.declarationPath
            )
            
            return VarType.Inferred(info)
        } else {
            errors.append(VarTypeInferenceError.NoDeclarationCode)
        }
        
        return VarType.Unknown(errors)
    }
    
    private func strictVarType(typeName typeName: String) -> VarType {
        var errors = [VarTypeInferenceError]()
        
        if let declarationCode = codeScanner.scanCode() {
            let info = VarTypeInfo(
                typeName: typeName,
                declarationCode: declarationCode,
                declarationPath: dependencies.declarationPath
            )
            
            return VarType.Strict(info)
        } else {
            errors.append(VarTypeInferenceError.NoDeclarationCode)
        }
        
        return VarType.Unknown(errors)
    }
}