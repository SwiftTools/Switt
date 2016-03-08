//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct VarStaticDeclaration {
    public var name: String
    public var varType: VarType
    public var accessibility: Accessibility
    
    public init(name: String,
        varType: VarType,
        accessibility: Accessibility)
    {
        self.name = name
        self.varType = varType
        self.accessibility = accessibility
    }
}
