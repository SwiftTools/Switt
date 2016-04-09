import SwiftGrammar

// Pattern:
//    ([a-zA-Z]*?)(,?)$

// Var:
//var \l$1: $1

// Init:
//\l$1: $1$2

// Assignment:
//self.\l$1: \l$1

// Convert: (manually set context type)
//    ([A-Za-z]*?)(FromContextConverter)(,?)$
//func convert(context: Int?) -> $1? {\n    return \l$1$2.convert(context)\n}\n

protocol ConvertingAssemblyUniversalConverter: class,
    SwiftFileFromContextConverter,
    ClassFromContextConverter,
    StructFromContextConverter,
    EnumFromContextConverter,
    ProtocolFromContextConverter,
    TypealiasFromContextConverter,
    ProtocolFuncFromContextConverter,
    ProtocolSubscriptFromContextConverter,
    ProtocolInitFromContextConverter,
    ProtocolVarFromContextConverter,
    AssociatedTypeFromContextConverter,
    FuncFromContextConverter,
    FunctionNameFromContextConverter,
    AccessibilityFromContextConverter,
    FunctionSignatureFromContextConverter
{
}

class ConvertingAssemblyUniversalConverterImpl: ConvertingAssemblyUniversalConverter {
    var swiftFileFromContextConverter: SwiftFileFromContextConverter
    var classFromContextConverter: ClassFromContextConverter
    var structFromContextConverter: StructFromContextConverter
    var enumFromContextConverter: EnumFromContextConverter
    var protocolFromContextConverter: ProtocolFromContextConverter
    var typealiasFromContextConverter: TypealiasFromContextConverter
    var protocolFuncFromContextConverter: ProtocolFuncFromContextConverter
    var protocolSubscriptFromContextConverter: ProtocolSubscriptFromContextConverter
    var protocolInitFromContextConverter: ProtocolInitFromContextConverter
    var protocolVarFromContextConverter: ProtocolVarFromContextConverter
    var associatedTypeFromContextConverter: AssociatedTypeFromContextConverter
    var funcFromContextConverter: FuncFromContextConverter
    var functionNameFromContextConverter: FunctionNameFromContextConverter
    var accessibilityFromContextConverter: AccessibilityFromContextConverter
    var functionSignatureFromContextConverter: FunctionSignatureFromContextConverter
    
    init(
        swiftFileFromContextConverter: SwiftFileFromContextConverter,
        classFromContextConverter: ClassFromContextConverter,
        structFromContextConverter: StructFromContextConverter,
        enumFromContextConverter: EnumFromContextConverter,
        protocolFromContextConverter: ProtocolFromContextConverter,
        typealiasFromContextConverter: TypealiasFromContextConverter,
        protocolFuncFromContextConverter: ProtocolFuncFromContextConverter,
        protocolSubscriptFromContextConverter: ProtocolSubscriptFromContextConverter,
        protocolInitFromContextConverter: ProtocolInitFromContextConverter,
        protocolVarFromContextConverter: ProtocolVarFromContextConverter,
        associatedTypeFromContextConverter: AssociatedTypeFromContextConverter,
        funcFromContextConverter: FuncFromContextConverter,
        functionNameFromContextConverter: FunctionNameFromContextConverter,
        accessibilityFromContextConverter: AccessibilityFromContextConverter,
        functionSignatureFromContextConverter: FunctionSignatureFromContextConverter
        )
    {
        self.swiftFileFromContextConverter = swiftFileFromContextConverter
        self.classFromContextConverter = classFromContextConverter
        self.structFromContextConverter = structFromContextConverter
        self.enumFromContextConverter = enumFromContextConverter
        self.protocolFromContextConverter = protocolFromContextConverter
        self.typealiasFromContextConverter = typealiasFromContextConverter
        self.protocolFuncFromContextConverter = protocolFuncFromContextConverter
        self.protocolSubscriptFromContextConverter = protocolSubscriptFromContextConverter
        self.protocolInitFromContextConverter = protocolInitFromContextConverter
        self.protocolVarFromContextConverter = protocolVarFromContextConverter
        self.associatedTypeFromContextConverter = associatedTypeFromContextConverter
        self.funcFromContextConverter = funcFromContextConverter
        self.functionNameFromContextConverter = functionNameFromContextConverter
        self.accessibilityFromContextConverter = accessibilityFromContextConverter
        self.functionSignatureFromContextConverter = functionSignatureFromContextConverter
    }
    
    func convert(context: SwiftParser.Top_levelContext?) -> SwiftFile? {
        return swiftFileFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Class_declarationContext?) -> Class? {
        return classFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Struct_declarationContext?) -> Struct? {
        return structFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Enum_declarationContext?) -> Enum? {
        return enumFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Protocol_declarationContext?) -> Protocol? {
        return protocolFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Typealias_declarationContext?) -> Typealias? {
        return typealiasFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Protocol_method_declarationContext?) -> ProtocolFunc? {
        return protocolFuncFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Protocol_subscript_declarationContext?) -> ProtocolSubscript? {
        return protocolSubscriptFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Protocol_initializer_declarationContext?) -> ProtocolInit? {
        return protocolInitFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Protocol_property_declarationContext?) -> ProtocolVar? {
        return protocolVarFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Protocol_associated_type_declarationContext?) -> AssociatedType? {
        return associatedTypeFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Function_declarationContext?) -> Func? {
        return funcFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Function_nameContext?) -> FunctionName? {
        return functionNameFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Access_level_modifierContext?) -> Accessibility? {
        return accessibilityFromContextConverter.convert(context)
    }
    
    func convert(context: SwiftParser.Function_signatureContext?) -> FunctionSignature? {
        return functionSignatureFromContextConverter.convert(context)
    }
}