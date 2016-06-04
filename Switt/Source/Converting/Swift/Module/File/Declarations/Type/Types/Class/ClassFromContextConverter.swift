import SwiftGrammar

protocol ClassFromContextConverter {
    func convert(context: SwiftParser.Class_declarationContext?) -> Class?
}

class ClassFromContextConverterImpl: ClassFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Class_declarationContext?) -> Class? {
        if let context = context {
            guard let name = context.class_name()?.getText() else {
                return nil
            }
            
            guard let accessibility = assembly.converter().convert(context.access_level_modifier()) else {
                return nil
            }
            
            var inits = [Init]()
            var deinits = [Deinit]()
            var funcs = [Func]()
            var classes = [Class]()
            var structs = [Struct]()
            var typealiases = [Typealias]()
            var vars = [Var]()
            var lets = [Let]()
            
            if let declarations: SwiftParser.DeclarationsContext = context.class_body()?.declarations() {
                let declarationContexts = assembly.declarationContextsScanner().scan(declarations)
                
                classes = declarationContexts.classDeclarations.flatMap { assembly.converter().convert($0) }
                structs = declarationContexts.structDeclarations.flatMap { assembly.converter().convert($0) }
                typealiases = declarationContexts.typealiasDeclarations.flatMap { assembly.converter().convert($0) }
                funcs = declarationContexts.functionDeclarations.flatMap { assembly.converter().convert($0) }
            }
            
            return ClassData(
                name: name,
                accessibility: accessibility,
                inits: inits,
                deinits: deinits,
                funcs: funcs,
                classes: classes,
                structs: structs,
                typealiases: typealiases,
                vars: vars,
                lets: lets
            )
        } else {
            return nil
        }
    }
}