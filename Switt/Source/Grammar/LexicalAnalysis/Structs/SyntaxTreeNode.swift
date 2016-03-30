struct SyntaxTreeNode: CustomDebugStringConvertible {
    var ruleName: RuleName
    var children: [SyntaxTree]
    
    init(ruleName: RuleName, children: [SyntaxTree] = []) {
        self.ruleName = ruleName
        self.children = children
    }
    
    var debugDescription: String {
        return "\(ruleName)" + StringUtils.wrapAndIndent(
            prefix: " {",
            infix: children.map { $0.debugDescription }.joinWithSeparator(",\n"),
            postfix: "}"
        )
    }
}