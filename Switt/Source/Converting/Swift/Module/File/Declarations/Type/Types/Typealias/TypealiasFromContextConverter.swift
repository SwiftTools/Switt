import SwiftGrammar

protocol TypealiasFromContextConverter {
    func convert(context: SwiftParser.Typealias_declarationContext?) -> Typealias?
}

class TypealiasFromContextConverterImpl: TypealiasFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Typealias_declarationContext?) -> Typealias? {
        return nil // TODO
    }
}