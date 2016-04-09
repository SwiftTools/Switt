import SwiftGrammar

protocol DeinitFromContextConverter {
}

class DeinitFromContextConverterImpl: DeinitFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}