class ConvertingAssemblyImpl: ConvertingAssembly {
    // See ConvertingAssemblyUniversalConverter
    // Impls:
    //\l$1: $1Impl(assembly: self)$2
    
    var weakConverter: ConvertingAssemblyUniversalConverter?
    
    func converter() -> ConvertingAssemblyUniversalConverter {
        if let converter = weakConverter {
            return converter
        } else {
            let converter = makeConverter()
            weakConverter = converter
            return converter
        }
    }
    
    private func makeConverter() -> ConvertingAssemblyUniversalConverter {
        return ConvertingAssemblyUniversalConverterImpl(
            swiftFileFromContextConverter: SwiftFileFromContextConverterImpl(assembly: self),
            classFromContextConverter: ClassFromContextConverterImpl(assembly: self),
            structFromContextConverter: StructFromContextConverterImpl(assembly: self),
            enumFromContextConverter: EnumFromContextConverterImpl(assembly: self),
            protocolFromContextConverter: ProtocolFromContextConverterImpl(assembly: self),
            typealiasFromContextConverter: TypealiasFromContextConverterImpl(assembly: self),
            protocolFuncFromContextConverter: ProtocolFuncFromContextConverterImpl(assembly: self),
            protocolSubscriptFromContextConverter: ProtocolSubscriptFromContextConverterImpl(assembly: self),
            protocolInitFromContextConverter: ProtocolInitFromContextConverterImpl(assembly: self),
            protocolVarFromContextConverter: ProtocolVarFromContextConverterImpl(assembly: self),
            associatedTypeFromContextConverter: AssociatedTypeFromContextConverterImpl(assembly: self),
            funcFromContextConverter: FuncFromContextConverterImpl(assembly: self),
            functionNameFromContextConverter: FunctionNameFromContextConverterImpl(assembly: self),
            accessibilityFromContextConverter: AccessibilityFromContextConverterImpl(assembly: self),
            functionSignatureFromContextConverter: FunctionSignatureFromContextConverterImpl(assembly: self),
            parameterNameFromContextConverter: ParameterNameFromContextConverterImpl(),
            typeAnnotationFromContextConverter: TypeAnnotationFromContextConverterImpl(assembly: self),
            typeFromContextConverter: TypeFromContextConverterImpl(assembly: self),
            attributesFromContextConverter: AttributesFromContextConverterImpl(assembly: self),
            functionResultFromContextConverter: FunctionResultFromContextConverterImpl(assembly: self),
            genericArgumentsFromContextConverter:  GenericArgumentsFromContextConverterImpl(assembly: self),
            parameterFromContextConverter:  ParameterFromContextConverterImpl(assembly: self)
        )
    }
    
    func declarationContextsScanner() -> DeclarationContextsScanner {
        return DeclarationContextsScanner()
    }
}