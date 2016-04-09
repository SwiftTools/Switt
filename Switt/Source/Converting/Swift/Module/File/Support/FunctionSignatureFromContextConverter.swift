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
        return nil // TODO
    }
}