import SwiftGrammar

protocol VarFromContextConverter {
}

class VarFromContextConverterImpl: VarFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}