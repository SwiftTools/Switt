public struct FunctionSignature {
    public var curry: NonemptyArray<[Parameter]> // Swift 2 supports currying, will be removed in Swift 3.
    public var throwing: Throwing?
    public var result: FunctionResult
}

public extension FunctionSignature {
    public var parameters: [Parameter] {
        return curry.first
    }
}