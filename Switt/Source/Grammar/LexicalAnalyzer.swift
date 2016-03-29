protocol LexicalAnalyzer {
    func analyze(string: String, firstRule: RuleName?) -> SyntaxTree?
}

extension LexicalAnalyzer {
    func analyze(string: String) -> SyntaxTree? {
        return analyze(string, firstRule: nil)
    }
}

class LexicalAnalyzerImpl: LexicalAnalyzer {
    private let grammar: Grammar
    
    init(grammarFactory: GrammarFactory) {
        grammar = grammarFactory.grammar()
    }
    
    func analyze(string: String, firstRule: RuleName?) -> SyntaxTree? {
        let firstRule = firstRule ?? grammar.firstRule
        
        let lexer: Lexer = LexerImpl(
            lexerRules: grammar.grammarRules.lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(
                lexerRules: grammar.grammarRules.lexerRules
            )
        )
        
        let inputStream = CharacterInputStringStream(string: string)
        
        let parser = ParserImpl(
            parserRules: grammar.grammarRules.parserRules,
            firstRule: firstRule
        )
        
        return parser.parse(lexer.tokenize(inputStream))
    }
}