protocol Parser {
    func parse(tokenInputStream: TokenInputStream) -> SyntaxTree?
}

