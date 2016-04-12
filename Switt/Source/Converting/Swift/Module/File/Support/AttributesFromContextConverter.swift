import SwiftGrammar

protocol AttributesFromContextConverter {
    func convert(context: SwiftParser.AttributesContext?) -> Attributes?
}

class AttributesFromContextConverterImpl: AttributesFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.AttributesContext?) -> Attributes? {
        // guard let context = context else { return nil }
        
        return nil // TODO
    }
}