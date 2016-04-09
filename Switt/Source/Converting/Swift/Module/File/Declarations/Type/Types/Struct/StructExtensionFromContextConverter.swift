import SwiftGrammar

protocol StructExtensionFromContextConverter {

}

class StructExtensionFromContextConverterImpl: StructExtensionFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
}