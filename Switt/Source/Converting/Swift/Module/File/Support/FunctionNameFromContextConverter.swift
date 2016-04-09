import SwiftGrammar

protocol FunctionNameFromContextConverter {
    func convert(context: SwiftParser.Function_nameContext?) -> FunctionName?
}

class FunctionNameFromContextConverterImpl: FunctionNameFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Function_nameContext?) -> FunctionName? {
        if let context = context {
            if let text = context.identifier()?.getText() {
                return FunctionName.Function(text)
            } else if let text = context.swift_operator()?.getText() {
                return FunctionName.Operator(text)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}