import SwiftGrammar

protocol ProtocolFuncFromContextConverter {
    func convert(context: SwiftParser.Protocol_method_declarationContext?) -> ProtocolFunc?
}

class ProtocolFuncFromContextConverterImpl: ProtocolFuncFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Protocol_method_declarationContext?) -> ProtocolFunc? {
        if let context = context {
            guard let name = assembly.converter().convert(context.function_name()) else {
                return nil
            }
            
            guard let signature: FunctionSignature = assembly.converter().convert(context.function_signature()) else {
                return nil
            }
            
            return ProtocolFuncData(
                name: name,
                signature: signature
            )
        } else {
            return nil
        }
    }
}