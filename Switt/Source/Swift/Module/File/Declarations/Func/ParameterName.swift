// It looks like optional, but in this enum both cases represent something specific
public enum ParameterName: Equatable {
    case None // "_"
    case Some(String) // any identifier, e.g.: "a"
}

public func ==(left: ParameterName, right: ParameterName) -> Bool {
    switch (left, right) {
    case (.None, .None):
        return true
    case (.Some(let left), .Some(let right)):
        return true
    default:
        return false
    }
}