//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import Foundation

class FunctionScanner {
    private let dependencies: SourceKitStructureScanningDependencies
    private let codeScanner: SourceKitStructureCodeScanner
    
    init(dependencies: SourceKitStructureScanningDependencies) {
        self.dependencies = dependencies
        
        codeScanner = SourceKitStructureCodeScanner(
            sourceKitStructure: dependencies.sourceKitStructure,
            file: dependencies.file
        )
    }
    
    // TODO: nothing works here
    
    func name() -> String? {
        if let name = dependencies.sourceKitStructure.name {
            return name
        } else {
            return nil
        }
    }
    
    func nameAndArguments() -> String? {
        return dependencies.sourceKitStructure.name
    }
    
    func returnType() -> String? {
        return dependencies.sourceKitStructure.name
    }
    
    private func parseFunction() {
        
        //func doWork(a: Int, andB b: String) -> [String] {\n        return []\n    }
    }
}