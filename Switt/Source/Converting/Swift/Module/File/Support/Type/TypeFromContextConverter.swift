import SwiftGrammar

enum TypeContext {
    case Array(SwiftParser.TypeArrayContext)
    case Dictionary(SwiftParser.TypeDictionaryContext)
    case Closure(SwiftParser.TypeClosureContext)
    case Identifier(SwiftParser.TypeIdentifierContext)
    case ImplicitlyUnwrappedOptional(SwiftParser.TypeImplicitlyUnwrappedOptionalContext)
    case Optional(SwiftParser.TypeOptionalContext)
    case ProtocolComposition(SwiftParser.TypeProtocolCompositionContext)
    case ProtocolType(SwiftParser.TypeProtocolTypeContext)
    case Tuple(SwiftParser.TypeTupleContext)
    case TypeType(SwiftParser.TypeTypeTypeContext)
    
    static func from(context: SwiftParser.TypeContext) -> TypeContext? {
        switch context {
        case let context as SwiftParser.TypeArrayContext:
            return TypeContext.Array(context)
        case let context as SwiftParser.TypeDictionaryContext:
            return TypeContext.Dictionary(context)
        case let context as SwiftParser.TypeClosureContext:
            return TypeContext.Closure(context)
        case let context as SwiftParser.TypeIdentifierContext:
            return TypeContext.Identifier(context)
        case let context as SwiftParser.TypeImplicitlyUnwrappedOptionalContext:
            return TypeContext.ImplicitlyUnwrappedOptional(context)
        case let context as SwiftParser.TypeOptionalContext:
            return TypeContext.Optional(context)
        case let context as SwiftParser.TypeProtocolCompositionContext:
            return TypeContext.ProtocolComposition(context)
        case let context as SwiftParser.TypeProtocolTypeContext:
            return TypeContext.ProtocolType(context)
        case let context as SwiftParser.TypeTupleContext:
            return TypeContext.Tuple(context)
        case let context as SwiftParser.TypeTypeTypeContext:
            return TypeContext.TypeType(context)
            
        default:
            return nil
        }
    }
}

protocol TypeFromContextConverter {
    func convert(context: SwiftParser.TypeContext?) -> Type?
}

class TypeFromContextConverterImpl: TypeFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.TypeContext?) -> Type? {
        guard let context = context else { return nil }
        guard let typeContext = TypeContext.from(context) else { return nil }
        
        switch typeContext {
        case .Array(let context):
            return type(context)
        case .Dictionary(let context):
            return type(context)
        case .Closure(let context):
            return type(context)
        case .Identifier(let context):
            return type(context)
        case .ImplicitlyUnwrappedOptional(let context):
            return type(context)
        case .Optional(let context):
            return type(context)
        case .ProtocolComposition(let context):
            return type(context)
        case .ProtocolType(let context):
            return type(context)
        case .Tuple(let context):
            return type(context)
        case .TypeType(let context):
            return type(context)
        }
    }
    
    private func type(context: SwiftParser.TypeArrayContext) -> Type? {
        return convert(context.type()).flatMap { Type.Array($0) }
    }
    
    private func type(context: SwiftParser.TypeDictionaryContext) -> Type? {
        let types = context.type().flatMap { convert($0) }
        guard types.count == 2 else { return nil }
        return Type.Dictionary(types[0], types[1])
    }
    
    private func type(context: SwiftParser.TypeClosureContext) -> Type? {
        let types = context.type().flatMap { convert($0) }
        guard types.count == 2 else { return nil }
        return Type.Closure(
            ClosureType(
                argument: types[0],
                throwing: ThrowingFromTerminalsConverter.convert(context),
                returnType: types[1]
            )
        )
    }
    
    private func type(context: SwiftParser.TypeIdentifierContext?) -> Type? {
        guard let typeIdentifierElements =
            GrammarMath.unroll(
                context: context?.type_identifier(),
                element: { context in  typeIdentifierElement(context) },
                list: { context in context.type_identifier() }
            )
            else { return nil }
        
        guard let nonemptyTypeIdentifierElements =
            NonemptyArray<TypeIdentifierElement>(
                array: typeIdentifierElements
            )
            else { return nil }
        
        return Type.Identifier(
            TypeIdentifier(
                elements: nonemptyTypeIdentifierElements
            )
        )
    }
    
    private func type(context: SwiftParser.TypeImplicitlyUnwrappedOptionalContext) -> Type? {
        return convert(context.type()).flatMap { Type.ImplicitlyUnwrappedOptional($0) }
    }
    
    private func type(context: SwiftParser.TypeOptionalContext) -> Type? {
        return convert(context.type()).flatMap { Type.Optional($0) }
    }
    
    private func type(context: SwiftParser.TypeProtocolCompositionContext) -> Type? {
        guard let protocolIdentifierContexts = context
            .protocol_composition_type()?
            .protocol_identifier_list()?
            .protocol_identifier() else { return nil }
        
        let protocolTypeIdentifiers = protocolIdentifierContexts.flatMap { protocolTypeIdentifier($0) }
        
        guard let nonemptyProtocolTypeIdentifiers =
            NonemptyArray<ProtocolTypeIdentifier>(
                array: protocolTypeIdentifiers
            )
            else { return nil }
        
        return Type.ProtocolComposition(
            ProtocolCompositionType(
                types: nonemptyProtocolTypeIdentifiers
            )
        )
    }
    
    private func type(context: SwiftParser.TypeProtocolTypeContext) -> Type? {
        return convert(context.type()).flatMap { Type.ProtocolType($0) }
    }
    
    private func type(context: SwiftParser.TypeTupleContext) -> Type? {
        guard let tupleTypeBodyContext = context.tuple_type()?.tuple_type_body() else { return nil }
        
        guard let tupleTypeElementContexts =
            GrammarMath.unroll(
                context: tupleTypeBodyContext.tuple_type_element_list(),
                element: { context in context.tuple_type_element() },
                list: { context in context.tuple_type_element_list() }
            )
            else { return nil }
        
        let tupleTypeElements = tupleTypeElementContexts.flatMap(tupleTypeElement)
        
        guard let nonemptyTupleTypeElements = NonemptyArray<TupleTypeElement>(array: tupleTypeElements) else { return nil }
        
        let isVariadic = tupleTypeBodyContext.range_operator() != nil
        
        return Type.Tuple(
            TupleType(
                elements: nonemptyTupleTypeElements,
                isVariadic: isVariadic
            )
        )
    }
    
    private func type(context: SwiftParser.TypeTypeTypeContext) -> Type? {
        return convert(context.type()).flatMap { Type.TypeType($0) }
    }
    
    private func tupleTypeElement(context: SwiftParser.Tuple_type_elementContext) -> TupleTypeElement? {
        let isInout = context.mapTerminal([SwiftParser.SYM_INOUT: true]) ?? false
        
        let typeContext: SwiftParser.TypeContext?
        let attributesContext: SwiftParser.AttributesContext?
        
        if let typeAnnotationContext = context.type_annotation() {
            typeContext = typeAnnotationContext.type()
            attributesContext = typeAnnotationContext.attributes()
        } else {
            typeContext = context.type()
            attributesContext = context.attributes()
        }
        
        guard let type = assembly.converter().convert(typeContext) else { return nil }
        let attributes = assembly.converter().convert(attributesContext)
        
        return TupleTypeElement(
            attributes: attributes,
            isInout: isInout,
            name: context.element_name()?.identifier()?.getText(),
            type: type
        )
    }
    
    private func protocolTypeIdentifier(context: SwiftParser.Protocol_identifierContext?) -> ProtocolTypeIdentifier? {
        guard let typeIdentifierElements =
            GrammarMath.unroll(
                context: context?.type_identifier(),
                element: { context in typeIdentifierElement(context) },
                list: { context in context.type_identifier() }
            )
            else { return nil }
        
        // Protocols has no generic arguments:
        guard let last = typeIdentifierElements.last where last.genericArguments == nil else { return nil }
        
        return ProtocolTypeIdentifier(
            path: typeIdentifierElements.dropLast().map { $0 },
            name: last.name
        )
    }
    
    private func typeIdentifierElement(context: SwiftParser.Type_identifierContext) -> TypeIdentifierElement? {
        guard let name = context.type_name()?.getText() else { return nil }
        let genericArguments = assembly.converter().convert(context.generic_argument_clause())
        
        return TypeIdentifierElement(
            name: name,
            genericArguments: genericArguments
        )
    }
}