//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

final class SwiftFileScanner {
    private let file: SourceKitFile
    private let logger: SourceKitStructureScanningLogger
    
    init(file: SourceKitFile, logger: SourceKitStructureScanningLogger) {
        self.file = file
        self.logger = logger
    }
    
    convenience init?(path: String, logger: SourceKitStructureScanningLogger, reader: SourceKitFileReader) {
        if let file = reader.readFile(path) {
            self.init(file: file, logger: logger)
        } else {
            return nil
        }
    }
    
    func scanDeclarations() -> TopLevelDeclarations {
        var topLevelDeclarations = TopLevelDeclarations()
        
        var declarations: [Declaration] = []
        
        for sourceKitStructure in file.structure.substructure {
            let declarationPath = DeclarationPath(
                path: []
            )
            
            let dependencies = SourceKitStructureScanningDependencies(
                sourceKitStructure: sourceKitStructure,
                file: file,
                declarationPath: declarationPath,
                logger: logger
            )
            
            let sourceKitStructureScanner = SourceKitStructureScanner(dependencies: dependencies)
            
            let subDeclarations = sourceKitStructureScanner.scanDeclarations()
            
            declarations.appendContentsOf(subDeclarations)
        }
        
        for declaration in declarations {
            switch declaration {
            case .Class(let declaration):
                topLevelDeclarations.classes.append(declaration)
            case .Struct(let declaration):
                topLevelDeclarations.structs.append(declaration)
            case .Protocol(let declaration):
                topLevelDeclarations.protocols.append(declaration)
            default:
                logger.logUnexpectedDeclaration(declaration, inScanner: self)
            }
        }
        
        return topLevelDeclarations
    }
}