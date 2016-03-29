protocol TokenParser {
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? 
}