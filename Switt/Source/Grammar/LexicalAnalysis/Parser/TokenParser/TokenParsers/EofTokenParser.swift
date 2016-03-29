class EofTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        if inputStream.defaultChannel().token() == nil {
            return SyntaxTree.success()
        } else {
            position.restore()
            return SyntaxTree.fail()
        }
    }
}