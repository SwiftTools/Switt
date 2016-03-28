@testable import Switt

extension SyntaxTree {
    var token: Token? {
        switch self {
        case .Leaf(let token):
            return token
        default:
            return nil
        }
    }
    
    var node: SyntaxTreeNode? {
        switch self {
        case .Node(let node):
            return node
        default:
            return nil
        }
    }
}