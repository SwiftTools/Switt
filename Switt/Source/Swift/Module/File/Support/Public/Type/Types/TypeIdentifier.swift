public struct TypeIdentifier {
    public var elements: NonemptyArray<TypeIdentifierElement>
    
    public init(elements: NonemptyArray<TypeIdentifierElement>) {
        self.elements = elements
    }
}

public struct TypeIdentifierElement {
    public var name: String
    public var genericArguments: GenericArguments?
    
    public init(name: String, genericArguments: GenericArguments? = nil) {
        self.name = name
        self.genericArguments = genericArguments
    }
}

// A<Int, String>.B<A<Int, String>>.SomeTypealias
public struct ProtocolTypeIdentifier {
    public var path: [TypeIdentifierElement] // A<Int, String> B<A<Int, String>>
    public var name: String // SomeTypealias
}