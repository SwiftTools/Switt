@testable import Switt

class LexicalAnalysisTestHelper {
    private let lexicalAnalyzer = LexicalAnalyzerImpl(grammarFactory: SwiftGrammarFactory())
    
    func isSuccess(code: String, firstRule: RuleName? = nil) -> Bool {
        return analyze(code, firstRule: firstRule) != nil
    }
    
    func analyze(code: String, firstRule: RuleName? = nil) -> SyntaxTree? {
        return lexicalAnalyzer.analyze(code, firstRule: firstRule)
    }
}