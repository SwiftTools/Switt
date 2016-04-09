public struct TypeIdentifier {
    var elements: NonemptyArray<TypeIdentifierElement>
}

public struct TypeIdentifierElement {
    var name: String
    var genericArguments: GenericArguments?
}