protocol CustomTokenParserFactory: class {
    var involvedTerminals: [String] { get }
    
    func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser
}