class OperatorTokenParser: TokenParser {
    private let operatorName: String
    private let tokenParserFactory: TokenParserFactory
    
    init(operatorName: String, tokenParserFactory: TokenParserFactory) {
        self.operatorName = operatorName
        self.tokenParserFactory = tokenParserFactory
    }
    
    func parse(inputStream: TokenInputStream) -> [SyntaxTree]? {
        let parser = DisallowHiddenTokensTokenParser(
            parserRule: ParserRule.Sequence(
                rules: operatorName.characters.map { String($0) }.map { ParserRule.Terminal(terminal: $0) }
            ),
            tokenParserFactory: tokenParserFactory
        )
        return parser.parse(inputStream)
    }
}