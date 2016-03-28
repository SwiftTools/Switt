enum SyntaxTree {
    case Leaf(Token)
    case Node(SyntaxTreeNode)
    
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
}

struct SyntaxTreeNode {
    var ruleName: RuleName
    var children: [SyntaxTree]
    
    init(ruleName: RuleName, children: [SyntaxTree] = []) {
        self.ruleName = ruleName
        self.children = children
    }
}