import SwiftGrammar

protocol AssociatedTypeFromContextConverter {
    func convert(context: SwiftParser.Protocol_associated_type_declarationContext?) -> AssociatedType?
}


class AssociatedTypeFromContextConverterImpl: AssociatedTypeFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Protocol_associated_type_declarationContext?) -> AssociatedType? {
        return nil // TODO
    }
}