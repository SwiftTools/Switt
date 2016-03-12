//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct VarParameterDeclaration {
    public var externalName: String?
    public var localName: String
    public var type: String
    
    public init(externalName: String?,
        localName: String,
        type: String)
    {
        self.externalName = externalName
        self.localName = localName
        self.type = type
    }
}
