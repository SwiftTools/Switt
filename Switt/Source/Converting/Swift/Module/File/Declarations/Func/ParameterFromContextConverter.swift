import SwiftGrammar

protocol ParameterFromContextConverter {
    func convert(context: SwiftParser.Parameter_clausesContext?) -> [[Parameter]]?
}

class ParameterFromContextConverterImpl: ParameterFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Parameter_clausesContext?) -> [[Parameter]]? {
        guard let parameterClauses =
            GrammarMath.unroll(
                context: context,
                element: { context in context.parameter_clause() },
                list: { context in context.parameter_clauses() }
            )
            else { return nil }
        
        return parameterClauses.flatMap { convert($0.parameter_list()) }
    }
    
    func convert(context: SwiftParser.ParameterContext?) -> Parameter? {
        guard let context = context else { return nil }
        guard let localName = assembly.converter().convert(context.local_parameter_name()) else { return nil }
        guard let type = assembly.converter().convert(context.type_annotation()) else { return nil }
            
        return ParameterData(
            externalName: assembly.converter().convert(context.external_parameter_name()),
            localName: localName,
            type: type
        )
    }
    
    func convert(context: SwiftParser.Parameter_listContext?) -> [Parameter]? {
        return context?.parameter().flatMap { convert($0) }
    }
}