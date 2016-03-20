struct SyntaxTree {
    var token: Token
    var nodes: [SyntaxTree]
    
    init(token: Token, nodes: [SyntaxTree]) {
        self.token = token
        self.nodes = nodes
    }
}