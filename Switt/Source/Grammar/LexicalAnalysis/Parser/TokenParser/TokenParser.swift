protocol TokenParser {
    func parse(inputStream: TokenInputStream) -> TokenParserResult
}