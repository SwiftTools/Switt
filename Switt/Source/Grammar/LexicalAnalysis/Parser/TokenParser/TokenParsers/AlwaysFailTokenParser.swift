class AlwaysFailTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        return SyntaxTree.fail()
    }
}