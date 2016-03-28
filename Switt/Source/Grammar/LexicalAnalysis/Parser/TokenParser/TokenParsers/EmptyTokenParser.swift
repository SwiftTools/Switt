class EmptyTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        return SyntaxTree.success()
    }
}