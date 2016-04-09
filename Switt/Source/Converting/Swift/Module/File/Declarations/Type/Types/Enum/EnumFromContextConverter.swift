import SwiftGrammar

protocol EnumFromContextConverter {
    func convert(context: SwiftParser.Enum_declarationContext?) -> Enum?
}

class EnumFromContextConverterImpl: EnumFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Enum_declarationContext?) -> Enum? {
        return nil // TODO
    }
}