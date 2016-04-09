import SwiftGrammar

protocol ProtocolVarFromContextConverter {
    func convert(context: SwiftParser.Protocol_property_declarationContext?) -> ProtocolVar?
}

class ProtocolVarFromContextConverterImpl: ProtocolVarFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Protocol_property_declarationContext?) -> ProtocolVar? {
        return nil // TODO
    }
}