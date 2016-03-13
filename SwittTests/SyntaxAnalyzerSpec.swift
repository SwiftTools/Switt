import Quick
import Nimble

@testable import Switt

class SyntaxAnalyzerSpec: QuickSpec {
    override func spec() {
        describe("SyntaxAnalyzer") {
            it("does stuff and things") {
                let grammarFactory: GrammarFactory = SwiftGrammarRulesBuilder()
                
                let lexicalAnalyzer = LexicalAnalyzer()
                let result = lexicalAnalyzer.analyze(
                    "[:]",
                    grammar: grammarFactory.grammar(),
                    firstRule: .dictionary_literal
                )
                
                switch result {
                case .Fail:
                    fail()
                default:
                    break
                }
            }
        }
    }
}