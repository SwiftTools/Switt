class EofTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        let position = inputStream.position
        
        if inputStream.getToken() == nil {
            return SyntaxTree.success()
        } else {
            position.restore()
            return SyntaxTree.fail()
        }
    }
}