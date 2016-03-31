@testable import Switt

class LexicalAnalysisTestHelper {
    private let lexicalAnalyzer: LexicalAnalyzer
    private let lexer: Lexer
    
    init() {
        let grammarFactory = CachedSwiftGrammarFactory.instance
        let grammar = grammarFactory.grammar()
        
        lexicalAnalyzer = LexicalAnalyzerImpl(grammarFactory: grammarFactory)
        
        lexer = LexerImpl(
            lexerRules: grammar.grammarRules.lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(
                lexerRules: grammar.grammarRules.lexerRules
            )
        )
    }
    
    func isSuccess(code: String, firstRule: RuleName? = nil) -> Bool {
        return analyze(code, firstRule: firstRule) != nil
    }
    
    func analyze(code: String, firstRule: RuleName? = nil) -> SyntaxTree? {
        return lexicalAnalyzer.analyze(code, firstRule: firstRule)
    }
    
    func tokenize(code: String) -> [Token] {
        let inputStream = CharacterInputStringStream(string: code)
        return lexer.tokenize(inputStream).tokens
    }
    
    func tokenIdentifiers(code: String) -> [RuleIdentifier] {
        let inputStream = CharacterInputStringStream(string: code)
        return lexer.tokenize(inputStream).tokens.map { $0.ruleIdentifier }
    }
}