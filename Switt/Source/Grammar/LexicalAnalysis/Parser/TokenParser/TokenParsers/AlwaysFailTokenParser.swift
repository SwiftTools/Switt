class AlwaysFailTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        return SyntaxTree.fail()
    }
}