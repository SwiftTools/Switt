struct Grammar {
    var grammarRules: GrammarRules
    var firstRule: RuleName
}

struct GrammarRules {
    var lexerRules: LexerRules = LexerRules()
    var parserRules: ParserRules = ParserRules()
}