//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct VarStaticDeclaration {
    public var name: String
    public var type: String?
    public var expression: String
    public var accessibility: Accessibility
    
    public init(name: String,
        type: String?,
        expression: String,
        accessibility: Accessibility)
    {
        self.name = name
        self.type = type
        self.expression = expression
        self.accessibility = accessibility
    }
}
