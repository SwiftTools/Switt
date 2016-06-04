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
        
        let result = assembly.converter().convert(context.function_result())
            
        let throwing = ThrowingFromTerminalsConverter.convert(context)
        
        let parameters = assembly.converter().convert(context.parameter_clauses()) ?? []
        
        return FunctionSignature(
            curry: NonemptyArray(array: parameters) ?? NonemptyArray(first: []),
            throwing: throwing,
            result: result
        )
    }
}