class EofTokenParser: TokenParser {
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let position = inputStream.position
        
        inputStream.moveToToken { $0.channel ~= .Default }
        
        if inputStream.token() == nil {
            return SyntaxTree.success()
        } else {
            position.restore()
            return SyntaxTree.fail()
        }
    }
}