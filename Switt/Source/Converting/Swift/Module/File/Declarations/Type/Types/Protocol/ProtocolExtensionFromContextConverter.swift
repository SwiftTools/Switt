import SwiftGrammar

protocol ProtocolExtensionFromContextConverter {
}

class ProtocolExtensionFromContextConverterImpl: ProtocolExtensionFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}