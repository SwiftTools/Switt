protocol TokenParserFactory {
    func tokenParser(rule: ParserRule) -> TokenParser
    func tokenParser(ruleIdentifier: RuleIdentifier) -> ReferencedTokenParser?
}



