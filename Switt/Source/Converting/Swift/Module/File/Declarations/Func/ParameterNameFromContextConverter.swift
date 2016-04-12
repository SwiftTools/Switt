import SwiftGrammar
import Antlr4

protocol ParameterNameFromContextConverter {
    func convert(context: SwiftParser.Local_parameter_nameContext?) -> ParameterName?
    func convert(context: SwiftParser.External_parameter_nameContext?) -> ParameterName?
}

class ParameterNameFromContextConverterImpl: ParameterNameFromContextConverter {
    func convert(context: SwiftParser.Local_parameter_nameContext?) -> ParameterName? {
        return convert(context, identifierContext: context?.identifier())
    }
    
    func convert(context: SwiftParser.External_parameter_nameContext?) -> ParameterName? {
        return convert(context, identifierContext: context?.identifier())
    }
    
    func convert(context: ParserRuleContext?, identifierContext: SwiftParser.IdentifierContext?) -> ParameterName? {
        if let context = context {
            if let identifier = identifierContext?.getText() {
                return ParameterName.Some(identifier)
            } else {
                return context.mapTerminal([SwiftParser.UNDERSCORE: ParameterName.None])
            }
        } else {
            return nil
        }
    }
}