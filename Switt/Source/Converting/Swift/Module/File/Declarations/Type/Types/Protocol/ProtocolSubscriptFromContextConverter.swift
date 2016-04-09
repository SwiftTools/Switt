import SwiftGrammar

protocol ProtocolSubscriptFromContextConverter {
    func convert(context: SwiftParser.Protocol_subscript_declarationContext?) -> ProtocolSubscript?
}

final class ProtocolSubscriptFromContextConverterImpl: ProtocolSubscriptFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Protocol_subscript_declarationContext?) -> ProtocolSubscript? {
        return nil // TODO
    }
}