//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct StructDeclaration {
    public var name: String
    public var runtimeName: String
    public var accessibility: Accessibility
    
    public var inits: [FunctionConstructorDeclaration]
    public var deinits: [FunctionDestructorDeclaration]
    
    public var instanceMethods: [FunctionMethodInstanceDeclaration]
    public var staticMethods: [FunctionMethodStaticDeclaration]
    
    public var nestedClasses: [ClassDeclaration]
    public var nestedStructs: [StructDeclaration]
    public var nestedTypealiases: [TypealiasDeclaration]
    
    public init(name: String,
        runtimeName: String,
        accessibility: Accessibility,
        
        inits: [FunctionConstructorDeclaration],
        deinits: [FunctionDestructorDeclaration],
        
        instanceMethods: [FunctionMethodInstanceDeclaration],
        staticMethods: [FunctionMethodStaticDeclaration],
        
        nestedClasses: [ClassDeclaration],
        nestedStructs: [StructDeclaration],
        nestedTypealiases: [TypealiasDeclaration])
    {
        self.name = name
        self.runtimeName = runtimeName
        self.accessibility = accessibility
        
        self.inits = inits
        self.deinits = deinits
        
        self.instanceMethods = instanceMethods
        self.staticMethods = staticMethods
        
        self.nestedClasses = nestedClasses
        self.nestedStructs = nestedStructs
        self.nestedTypealiases = nestedTypealiases
    }
}
