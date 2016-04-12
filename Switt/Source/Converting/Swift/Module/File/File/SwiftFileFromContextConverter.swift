import SwiftGrammar

protocol SwiftFileFromContextConverter {
    func convert(context: SwiftParser.Top_levelContext?) -> SwiftFile?
}

class SwiftFileFromContextConverterImpl: SwiftFileFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Top_levelContext?) -> SwiftFile? {
        if let context = context {
            let declarations = context.statement().flatMap { $0.declaration() }
            
            let declarationContexts = assembly.declarationContextsScanner().scan(declarations)
            
            return SwiftFileData(
                classes: declarationContexts.classDeclarations.flatMap { assembly.converter().convert($0) },
                structs: declarationContexts.structDeclarations.flatMap { assembly.converter().convert($0) },
                protocols: declarationContexts.protocolDeclarations.flatMap { assembly.converter().convert($0) },
                enums: declarationContexts.enumDeclarations.flatMap { assembly.converter().convert($0) }
            )
        } else {
            return nil
        }
    }
}