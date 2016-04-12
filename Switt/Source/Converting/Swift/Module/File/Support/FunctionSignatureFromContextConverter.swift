import SwiftGrammar

protocol FunctionSignatureFromContextConverter {
    func convert(context: SwiftParser.Function_signatureContext?) -> FunctionSignature?
}

class FunctionSignatureFromContextConverterImpl: FunctionSignatureFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Function_signatureContext?) -> FunctionSignature? {
        guard let context = context else { return nil }
        guard let result = assembly.converter().convert(context.function_result()) else { return nil }
            
        let throwing = ThrowingFromTerminalsConverter.convert(context)
        
        return FunctionSignature(
            parameters: assembly.converter().convert(context.parameter_clauses()) ?? [],
            throwing: throwing,
            result: result
        )
    }
}