//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct VarParameterDeclaration {
    public var name: String
    public var varType: VarType
    
    public init(name: String, varType: VarType) {
        self.name = name
        self.varType = varType
    }
}
