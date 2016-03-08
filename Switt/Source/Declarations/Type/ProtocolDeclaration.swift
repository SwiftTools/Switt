//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct ProtocolDeclaration {
    public var name: String
    public var runtimeName: String
    public var accessibility: Accessibility
    
    // Construction
    public var inits: [FunctionConstructorDeclaration]
    public var deinits: [FunctionDestructorDeclaration]
    
    // Methods
    public var instanceMethods: [FunctionMethodInstanceDeclaration]
    public var classMethods: [FunctionMethodClassDeclaration]
    public var staticMethods: [FunctionMethodStaticDeclaration]
    
    // Types
    public var typealiases: [TypealiasDeclaration]
    
    // Vars
    public var instanceVars: [VarInstanceDeclaration]
    
    public init(name: String,
        runtimeName: String,
        accessibility: Accessibility,
        
        // Construction
        inits: [FunctionConstructorDeclaration],
        deinits: [FunctionDestructorDeclaration],
        
        // Methods
        instanceMethods: [FunctionMethodInstanceDeclaration],
        classMethods: [FunctionMethodClassDeclaration],
        staticMethods: [FunctionMethodStaticDeclaration],
        
        // Types
        typealiases: [TypealiasDeclaration],
        
        // Vars
        instanceVars: [VarInstanceDeclaration])
    {
        
        self.name = name
        self.runtimeName = runtimeName
        self.accessibility = accessibility
        
        // Construction
        self.inits = inits
        self.deinits = deinits
        
        // Methods
        self.instanceMethods = instanceMethods
        self.classMethods = classMethods
        self.staticMethods = staticMethods
        
        // Types
        self.typealiases = typealiases
        
        // Vars
        self.instanceVars = instanceVars
    }
}
