public enum FunctionName: Equatable {
    case Function(String)
    case Operator(String)
}

public func ==(left: FunctionName, right: FunctionName) -> Bool {
    switch (left, right) {
    case (.Function(let left), .Function(let right)):
        return left == right
    case (.Operator(let left), .Operator(let right)):
        return left == right
    default:
        return false
    }
}