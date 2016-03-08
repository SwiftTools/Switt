//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

class SourceKitStructureCodeScanner {
    private let sourceKitStructure: SourceKitStructure
    private let file: SourceKitFile
    
    init(sourceKitStructure: SourceKitStructure, file: SourceKitFile) {
        self.sourceKitStructure = sourceKitStructure
        self.file = file
    }
    
    func scanName() -> String? {
        return scanSymbols(offset: sourceKitStructure.nameoffset, length: sourceKitStructure.namelength)
    }
    
    func scanBody() -> String? {
        return scanSymbols(offset: sourceKitStructure.bodyoffset, length: sourceKitStructure.bodylength)
    }
    
    func scanCode() -> String? {
        return scanSymbols(offset: sourceKitStructure.offset, length: sourceKitStructure.length)
    }
    
    // TODO: handle overflow
    private func scanSymbols(offset offset: Int64?, length: Int64?) -> String? {
        if let offset = offset, length = length {
            let contents = self.file.contents
            let startIndex = contents.startIndex.advancedBy(Int(offset))
            let endIndex = startIndex.advancedBy(Int(length))
            return contents.substringWithRange(startIndex..<endIndex)
        } else {
            return nil
        }
    }
}