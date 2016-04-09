public protocol Enum {
    // Cases
    var cases: [EnumCase] { get }
    
    // Funcs
    var funcs: [Func] { get }
    var staticFuncs: [Func] { get }
    
    // Nested types
    var classes: [Class] { get }
    var structs: [Struct] { get }
    var typealiases: [Typealias] { get }
    
    // Vars
    var vars: [Var] { get }
    var staticVars: [Var] { get }
}