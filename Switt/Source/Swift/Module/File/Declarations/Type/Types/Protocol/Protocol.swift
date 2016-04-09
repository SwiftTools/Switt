protocol Protocol {
    var name: String { get }
    var accessibility: Accessibility { get }
    
    var inits: [ProtocolInit] { get }
    var funcs: [ProtocolFunc] { get }
    var associatedTypes: [AssociatedType] { get }
    var vars: [ProtocolVar] { get }
    var subscripts: [ProtocolSubscript] { get }
}

struct ProtocolData: Protocol {
    var name: String
    var accessibility: Accessibility
    
    var inits: [ProtocolInit]
    var funcs: [ProtocolFunc]
    var associatedTypes: [AssociatedType]
    var vars: [ProtocolVar]
    var subscripts: [ProtocolSubscript]
}