public indirect enum Type {
    case Array(Type) // [Int]
    case Dictionary(Type, Type) // [Int: Int]
    case Closure(ClosureType) // Int -> Int
    case Named(TypeIdentifier) // Int
    case Tuple(TupleType) // (Int, Int)
    case Optional(Type) // Int?
    case ImplicitlyUnwrappedOptional(Type) // Int!
    case ProtocolComposition(ProtocolCompositionType) // protocol<SequenceType, CustomStringConvertible>
    case TypeType(Type) // Int.Type
    case ProtocolType(Type) // SequenceType.Protocol
}