class CheckTokenParser: TokenParser {
    private let function: ProductionRuleCheckFunction
    
    init(function: ProductionRuleCheckFunction) {
        self.function = function
    }
    
    func parse(inputStream: TokenInputStream) -> TokenParserResult {
        if function() {
            return SyntaxTree.success()
        } else {
            return SyntaxTree.fail()
        }
    }
}