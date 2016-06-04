public struct TupleType {
    public var elements: NonemptyArray<TupleTypeElement>
    public var isVariadic: Bool // (Int, Int...)
}

public struct TupleTypeElement {
    public var attributes: Attributes?
    public var isInout: Bool
    public var name: String?
    public var type: Type
}