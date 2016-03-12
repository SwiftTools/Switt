//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct FunctionMethodInstanceDeclaration {
    public var name: String // functionName
    public var nameAndArguments: String // functionName(_:a:b:c:)
    public var accessibility: Accessibility
    public var parameters: [VarParameterDeclaration]
    public var returnType: String
    public var genericPlaceholders: GenericPlaceholders
    
    public init(
        name: String,
        nameAndArguments: String,
        accessibility: Accessibility,
        parameters: [VarParameterDeclaration],
        returnType: String,
        genericPlaceholders: GenericPlaceholders)
    {
        self.name = name
        self.nameAndArguments = nameAndArguments
        self.accessibility = accessibility
        self.parameters = parameters
        self.returnType = returnType
        self.genericPlaceholders = genericPlaceholders
    }
}
