//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

class SourceKitSubstructureScanner {
    private let substructure: [SourceKitStructure]
    private let file: SourceKitFile
    private let declarationPath: DeclarationPath
    private let logger: SourceKitStructureScanningLogger
    
    init(substructure: [SourceKitStructure], file: SourceKitFile, declarationPath: DeclarationPath, logger: SourceKitStructureScanningLogger) {
        self.substructure = substructure
        self.file = file
        self.declarationPath = declarationPath
        self.logger = logger
    }
    
    func scanDeclarations() -> [Declaration] {
        var declarations = [Declaration]()
        
        for structure in substructure {
            let dependencies = SourceKitStructureScanningDependencies(
                sourceKitStructure: structure,
                file: file,
                declarationPath: declarationPath,
                logger: logger
            )
            
            let sourceKitStructureScanner = SourceKitStructureScanner(dependencies: dependencies)
            
            let subDeclarations = sourceKitStructureScanner.scanDeclarations()
            
            declarations.appendContentsOf(subDeclarations)
        }
        
        return declarations
    }
}