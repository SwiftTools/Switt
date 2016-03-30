enum SyntaxTree: CustomDebugStringConvertible {
    case Leaf(Token)
    case Node(SyntaxTreeNode)
    
    var debugDescription: String {
        switch self {
        case .Leaf(let token):
            let ruleName: String
            switch token.ruleIdentifier {
            case .Named(let name):
                ruleName = name.rawValue
            case .Unnamed(let string):
                ruleName = string
            case .Unique(let id):
                ruleName = "UNIQUE(\(id.hashValue))" // unexpected in tree
            }
            return "\(ruleName) \"\(token.string)\""
        case .Node(let node):
            return node.debugDescription
        }
    }
}

extension SyntaxTree {
    static func success() -> [SyntaxTree] {
        return []
    }
    
    static func fail() -> [SyntaxTree]? {
        return nil
    }
    
    static func tree(ruleName: RuleName, _ children: [SyntaxTree] = []) -> [SyntaxTree] {
        return [
            SyntaxTree.Node(
                SyntaxTreeNode(
                    ruleName: ruleName,
                    children: children
                )
            )
        ]
    }
    
    static func leaf(token: Token) -> [SyntaxTree] {
        return [
            SyntaxTree.Leaf(token)
        ]
    }
    
    static func leftmostToken(nodes: [SyntaxTree]) -> Token? {
        return nodes.first?.leftmostToken
    }
    
    static func rightmostToken(nodes: [SyntaxTree]) -> Token? {
        return nodes.last?.leftmostToken
    }
    
    var leftmostToken: Token? {
        switch self {
        case .Leaf(let token):
            return token
        case .Node(let node):
            return SyntaxTree.leftmostToken(node.children)
        }
    }
    
    var rightmostToken: Token? {
        switch self {
        case .Leaf(let token):
            return token
        case .Node(let node):
            return SyntaxTree.rightmostToken(node.children)
        }
    }
}