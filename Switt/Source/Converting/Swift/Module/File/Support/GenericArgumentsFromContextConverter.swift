import SwiftGrammar

protocol GenericArgumentsFromContextConverter {
    func convert(context: SwiftParser.Generic_argument_clauseContext?) -> GenericArguments?
}

class GenericArgumentsFromContextConverterImpl: GenericArgumentsFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Generic_argument_clauseContext?) -> GenericArguments? {
        guard let context = context else { return nil }
        guard let argumentContexts = context.generic_argument_list()?.generic_argument() else { return nil }
        let types = argumentContexts.flatMap { assembly.converter().convert($0.type()) }
        guard let nonemptyTypes = NonemptyArray<Type>(array: types) else { return nil }
        
        return GenericArguments(
            types: nonemptyTypes
        )
    }
}