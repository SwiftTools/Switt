public struct TupleType {
    var elements: NonemptyArray<TupleTypeElement>
    var isVariadic: Bool // (Int, Int...)
}

public struct TupleTypeElement {
    var attributes: Attributes?
    var isInout: Bool
    var name: String?
    var type: Type
}