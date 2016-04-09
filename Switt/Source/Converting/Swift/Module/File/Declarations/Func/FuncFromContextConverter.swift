import SwiftGrammar

protocol FuncFromContextConverter {
    func convert(context: SwiftParser.Function_declarationContext?) -> Func?
}

class FuncFromContextConverterImpl: FuncFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Function_declarationContext?) -> Func? {
        return nil // TODO
    }
}