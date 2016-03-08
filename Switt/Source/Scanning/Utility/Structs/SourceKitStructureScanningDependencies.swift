//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

public struct SourceKitStructureScanningDependencies {
    public var sourceKitStructure: SourceKitStructure
    public var file: SourceKitFile
    public var declarationPath: DeclarationPath
    public var logger: SourceKitStructureScanningLogger
    
    public init(sourceKitStructure: SourceKitStructure,
        file: SourceKitFile,
        declarationPath: DeclarationPath,
        logger: SourceKitStructureScanningLogger)
    {
        self.sourceKitStructure = sourceKitStructure
        self.file = file
        self.declarationPath = declarationPath
        self.logger = logger
    }
}