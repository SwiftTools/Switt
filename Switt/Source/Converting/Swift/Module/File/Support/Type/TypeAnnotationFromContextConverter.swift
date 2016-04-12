import SwiftGrammar

protocol TypeAnnotationFromContextConverter {
    func convert(context: SwiftParser.Type_annotationContext?) -> TypeAnnotation?
}

class TypeAnnotationFromContextConverterImpl: TypeAnnotationFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Type_annotationContext?) -> TypeAnnotation? {
        guard let context = context else { return nil }
        guard let type = assembly.converter().convert(context.type()) else { return nil }
        
        return TypeAnnotation(
            attributes: assembly.converter().convert(context.attributes()),
            type: type
        )
    }
}