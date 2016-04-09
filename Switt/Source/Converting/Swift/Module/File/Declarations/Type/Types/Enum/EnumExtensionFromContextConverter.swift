import SwiftGrammar

protocol EnumExtensionFromContextConverter {
    
}

class EnumExtensionFromContextConverterImpl: EnumExtensionFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}