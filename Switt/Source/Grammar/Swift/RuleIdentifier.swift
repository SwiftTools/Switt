enum RuleIdentifier: Hashable, CustomDebugStringConvertible {
    case Named(RuleName)
    case Unnamed(String)
    case Unique(UniqueIdentifier)
    
    var hashValue: Int {
        switch self {
        case .Named(let ruleName):
            return ruleName.hashValue
        case .Unnamed(let terminal):
            return terminal.hashValue
        case .Unique(let uniqueIdentifier):
            return uniqueIdentifier.hashValue
        }
    }
    
    var debugDescription: String {
        switch self {
        case .Named(let ruleName):
            return "named(\(ruleName))"
        case .Unnamed(let terminal):
            return "unnamed(\(terminal))"
        case .Unique(let uniqueIdentifier):
            return "unique(hash: \(uniqueIdentifier.hashValue))"
        }
    }
}

func ==(left: RuleIdentifier, right: RuleIdentifier) -> Bool {
    switch (left, right) {
    case (.Named(let left), .Named(let right)):
        return left == right
    case (.Unnamed(let left), .Unnamed(let right)):
        return left == right
    case (.Unique(let left), .Unique(let right)):
        return left == right
    default:
        return false
    }
}