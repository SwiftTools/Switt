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
                if identifier == "_" {
                    return ParameterName.None
                } else {
                    return ParameterName.Some(identifier)
                }
            } else {
                // Not sure if this code is executed
                assertionFailure("This code is actually executed")
                return context.mapTerminal([SwiftParser.UNDERSCORE: ParameterName.None])
            }
        } else {
            return nil
        }
    }
}