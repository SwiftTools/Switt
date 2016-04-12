import SwiftGrammar

protocol FunctionResultFromContextConverter {
    func convert(context: SwiftParser.Function_resultContext?) -> FunctionResult?
}

class FunctionResultFromContextConverterImpl: FunctionResultFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Function_resultContext?) -> FunctionResult? {
        guard let context = context else { return nil }
        guard let type = assembly.converter().convert(context.type()) else { return nil }
        let attributes = assembly.converter().convert(context.attributes())
        
        return FunctionResult(
            attributes: attributes,
            type: type
        )
    }
}