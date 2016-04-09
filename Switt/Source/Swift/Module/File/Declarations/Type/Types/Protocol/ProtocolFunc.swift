public protocol ProtocolFunc {
    var name: FunctionName { get }
}

struct ProtocolFuncData: ProtocolFunc {
    var name: FunctionName
    var signature: FunctionSignature
}