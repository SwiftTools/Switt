class OperatorTokenParserFactory: CustomTokenParserFactory {
    private let operatorName: String
    
    init(operatorName: String) {
        self.operatorName = operatorName
    }
    
    var involvedTerminals: [String] {
        return operatorName.characters.map { String($0) }
    }
    
    func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser {
        return OperatorTokenParser(operatorName: operatorName, tokenParserFactory: tokenParserFactory)
    }
}