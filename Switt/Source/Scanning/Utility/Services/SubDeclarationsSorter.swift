//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

class SubDeclarationsSorter {
    private let dependencies: SourceKitStructureScanningDependencies
    
    init(dependencies: SourceKitStructureScanningDependencies) {
        self.dependencies = dependencies
    }
    
    func sortedSubDeclarations(inScanner scanner: AnyObject) -> SortedSubDeclarations {
        let subDeclarations = SortedSubDeclarations()
        
        let sourceKitSubstructureScanner = SourceKitSubstructureScanner(
            substructure: dependencies.sourceKitStructure.substructure,
            file: dependencies.file,
            declarationPath: dependencies.declarationPath,
            logger: dependencies.logger
        )
        
        let subdeclarations = sourceKitSubstructureScanner.scanDeclarations()
        
        for declaration in subdeclarations {
            switch declaration {
                // Types
            case .Class(let declaration):
                subDeclarations.classes.append(declaration)
            case .Struct(let declaration):
                subDeclarations.structs.append(declaration)
            case .Typealias(let declaration):
                subDeclarations.typealiases.append(declaration)
                
                // Inits/deinits
            case .FunctionConstructor(let declaration):
                subDeclarations.inits.append(declaration)
            case .FunctionDestructor(let declaration):
                subDeclarations.deinits.append(declaration)
                
                // Funcs
            case .FunctionMethodInstance(let declaration):
                subDeclarations.instanceMethods.append(declaration)
            case .FunctionMethodClass(let declaration):
                subDeclarations.classMethods.append(declaration)
            case .FunctionMethodStatic(let declaration):
                subDeclarations.staticMethods.append(declaration)
                
                // Var
            case .VarStatic(let declaration):
                subDeclarations.staticVars.append(declaration)
            case .VarInstance(let declaration):
                subDeclarations.instanceVars.append(declaration)
            case .VarParameter(let declaration):
                subDeclarations.parameters.append(declaration)
                
            default:
                dependencies.logger.logUnexpectedDeclaration(declaration, inScanner: scanner)
            }
        }
        
        return subDeclarations
    }
}