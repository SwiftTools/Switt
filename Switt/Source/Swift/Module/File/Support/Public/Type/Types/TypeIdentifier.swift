public struct TypeIdentifier {
    var elements: NonemptyArray<TypeIdentifierElement>
}

public struct TypeIdentifierElement {
    var name: String
    var genericArguments: GenericArguments?
}

// A<Int, String>.B<A<Int, String>>.SomeTypealias
public struct ProtocolTypeIdentifier {
    var path: [TypeIdentifierElement] // A<Int, String> B<A<Int, String>>
    var name: String // SomeTypealias
}