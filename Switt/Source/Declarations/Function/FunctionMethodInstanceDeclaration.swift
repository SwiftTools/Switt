//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct FunctionMethodInstanceDeclaration {
    public var parameters: [VarParameterDeclaration]
    public var genericPlaceholders: GenericPlaceholders
    
    public init(parameters: [VarParameterDeclaration], genericPlaceholders: GenericPlaceholders) {
        self.parameters = parameters
        self.genericPlaceholders = genericPlaceholders
    }
}
