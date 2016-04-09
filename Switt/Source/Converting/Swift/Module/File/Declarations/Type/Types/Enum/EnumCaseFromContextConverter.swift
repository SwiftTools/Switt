import SwiftGrammar

protocol EnumCaseFromContextConverter {
    
}

class EnumCaseFromContextConverterImpl: EnumCaseFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}