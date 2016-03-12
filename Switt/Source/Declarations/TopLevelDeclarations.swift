//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct TopLevelDeclarations {
    public var classes: [ClassDeclaration]
    public var structs: [StructDeclaration]
    public var protocols: [ProtocolDeclaration]
    
    public init(classes: [ClassDeclaration] = [],
        structs: [StructDeclaration] = [],
        protocols: [ProtocolDeclaration] = [])
    {
        self.classes = classes
        self.structs = structs
        self.protocols = protocols
    }
}