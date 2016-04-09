import SwiftGrammar

protocol ParameterFromContextConverter {
    
}

class ParameterFromContextConverterImpl: ParameterFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}