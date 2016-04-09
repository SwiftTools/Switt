import SwiftGrammar

protocol ClassExtensionFromContextConverter {
}

class ClassExtensionFromContextConverterImpl: ClassExtensionFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}