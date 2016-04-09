import SwiftGrammar

protocol InitFromContextConverter {
    
}

class InitFromContextConverterImpl: InitFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}