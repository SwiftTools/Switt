@testable import Switt

class LexicalAnalysisTestHelper {
    func isSuccess(code: String, firstRule: RuleName? = nil) -> Bool {
        let result: LexicalAnalysisResult = analyze(code, firstRule: firstRule)
        
        switch result {
        case .Fail:
            return false
        default:
            return true
        }
    }
    
    func analyze(code: String, firstRule: RuleName? = nil) -> LexicalAnalysisResult {
        let grammarFactory: GrammarFactory = SwiftGrammarFactory()
        
        let grammar = grammarFactory.grammar()
        
        let firstRule = firstRule ?? grammar.firstRule
        
        let lexicalAnalyzer = LexicalAnalyzer()
        
        let result = lexicalAnalyzer.analyze(
            code,
            grammar: grammarFactory.grammar(),
            firstRule: firstRule
        )
        
        return result
    }
}