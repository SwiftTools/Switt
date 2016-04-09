public protocol Class {
    var name: String { get }
    var accessibility: Accessibility { get }
    
    // Construction
    var inits: [Init] { get }
    var deinits: [Deinit] { get }
    
    // Funcs
    var funcs: [Func] { get }
    
    // Nested types
    var classes: [Class] { get }
    var structs: [Struct] { get }
    var typealiases: [Typealias] { get }
    
    // Vars
    var vars: [Var] { get }
    var lets: [Let] { get }
}

struct ClassData: Class {
    var name: String
    var accessibility: Accessibility
    
    // Construction
    var inits: [Init]
    var deinits: [Deinit]
    
    // Funcs
    var funcs: [Func]
    
    // Nested types
    var classes: [Class]
    var structs: [Struct]
    var typealiases: [Typealias]
    
    // Vars
    var vars: [Var]
    var lets: [Let]
}