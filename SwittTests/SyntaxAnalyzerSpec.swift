import Quick
import Nimble

@testable import Switt
import SwiftFelisCatus

class SyntaxAnalyzerSpec: QuickSpec {
    override func spec() {
        describe("SyntaxAnalyzer") {
            it("does stuff and things") {
                let grammarFactory: GrammarFactory = SwiftGrammarFactory()
                
                guard let swiftFile = SourceKitFileReader().readFile(TestSwiftFile.file) else {
                    fail()
                    return
                }
                
                let lexicalAnalyzer = LexicalAnalyzer()
                let result = lexicalAnalyzer.analyze(
                    swiftFile.contents,
                    grammar: grammarFactory.grammar()
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