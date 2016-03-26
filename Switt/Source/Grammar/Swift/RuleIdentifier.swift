enum RuleIdentifier: Hashable {
    case Named(RuleName)
    case Unnamed(String)
    
    var hashValue: Int {
        switch self {
        case .Named(let ruleName):
            return ruleName.hashValue
        case .Unnamed(let terminal):
            return terminal.hashValue
        }
    }
}

func ==(left: RuleIdentifier, right: RuleIdentifier) -> Bool {
    switch (left, right) {
    case (.Named(let left), .Named(let right)):
        return left == right
    case (.Unnamed(let left), .Unnamed(let right)):
        return left == right
    default:
        return false
    }
}