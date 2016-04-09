import SwiftGrammar

protocol StructFromContextConverter {
    func convert(context: SwiftParser.Struct_declarationContext?) -> Struct?
}

class StructFromContextConverterImpl: StructFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Struct_declarationContext?) -> Struct? {
        return nil // TODO
    }
}