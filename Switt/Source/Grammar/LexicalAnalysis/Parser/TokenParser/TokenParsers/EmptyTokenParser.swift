class EmptyTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        return SyntaxTree.success()
    }
}