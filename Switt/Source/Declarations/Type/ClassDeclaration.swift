//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public struct ClassDeclaration {
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
    public var nestedClasses: [ClassDeclaration]
    public var nestedStructs: [StructDeclaration]
    public var nestedTypealiases: [TypealiasDeclaration]
    
    // Vars
    public var staticVars: [VarStaticDeclaration]
    public var instanceVars: [VarInstanceDeclaration]
    
    public init(name: String,
        runtimeName: String,
        accessibility: Accessibility,
        
        // Construction
        inits: [FunctionConstructorDeclaration] = [],
        deinits: [FunctionDestructorDeclaration] = [],
        
        // Methods
        instanceMethods: [FunctionMethodInstanceDeclaration] = [],
        classMethods: [FunctionMethodClassDeclaration] = [],
        staticMethods: [FunctionMethodStaticDeclaration] = [],
        
        // Types
        nestedClasses: [ClassDeclaration] = [],
        nestedStructs: [StructDeclaration] = [],
        nestedTypealiases: [TypealiasDeclaration] = [],
        
        // Vars
        staticVars: [VarStaticDeclaration] = [],
        instanceVars: [VarInstanceDeclaration] = [])
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
        self.nestedClasses = nestedClasses
        self.nestedStructs = nestedStructs
        self.nestedTypealiases = nestedTypealiases
        
        // Vars
        self.staticVars = staticVars
        self.instanceVars = instanceVars
    }
}