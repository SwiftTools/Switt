public protocol ProtocolFunc {
    var name: FunctionName { get }
    var signature: FunctionSignature { get }
}

struct ProtocolFuncData: ProtocolFunc {
    var name: FunctionName
    var signature: FunctionSignature
}