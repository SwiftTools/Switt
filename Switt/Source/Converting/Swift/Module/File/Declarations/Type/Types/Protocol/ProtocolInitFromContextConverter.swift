import SwiftGrammar

protocol ProtocolInitFromContextConverter {
    func convert(context: SwiftParser.Protocol_initializer_declarationContext?) -> ProtocolInit?
}

class ProtocolInitFromContextConverterImpl: ProtocolInitFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Protocol_initializer_declarationContext?) -> ProtocolInit? {
        if let context = context {
            return ProtocolInitData(
                attributes: nil, // TODO
                declarationModifiers: [], // TODO
                parameters: [], // TODO
                throwing: nil, // TODO
                unwrapping: nil // TODO
            )
        } else {
            return nil
        }
    }
}