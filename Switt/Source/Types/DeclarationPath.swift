//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct DeclarationPath {
    public var path: [DeclarationTreeNode]
    
    public init(path: [DeclarationTreeNode]) {
        self.path = path
    }
    
    public func byAppendingPath(declaration: DeclarationTreeNode) -> DeclarationPath {
        var newPath = path
        newPath.append(declaration)
        return DeclarationPath(path: newPath)
    }
}

