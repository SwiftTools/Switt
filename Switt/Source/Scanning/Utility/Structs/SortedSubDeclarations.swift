//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

class SortedSubDeclarations {
    // Construction
    var inits: [FunctionConstructorDeclaration] = []
    var deinits: [FunctionDestructorDeclaration] = []
    
    // Methods
    var instanceMethods: [FunctionMethodInstanceDeclaration] = []
    var classMethods: [FunctionMethodClassDeclaration] = []
    var staticMethods: [FunctionMethodStaticDeclaration] = []
    
    // Types
    var classes: [ClassDeclaration] = []
    var structs: [StructDeclaration] = []
    var typealiases: [TypealiasDeclaration] = []
    
    // Vars
    var staticVars: [VarStaticDeclaration] = []
    var instanceVars: [VarInstanceDeclaration] = []
    var parameters: [VarParameterDeclaration] = []
}