import Quick
import Nimble
@testable import Switt

class TerminalTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("RepetitionTokenizer") {
            it("1") {
                let tokenizer = TerminalTokenizer(terminal: "a")
                
                let actualStates = "ab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("1") {
                let tokenizer = TerminalTokenizer(terminal: "ab")
                
                let actualStates = "abb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("1") {
                let tokenizer = TerminalTokenizer(terminal: "abc")
                
                let actualStates = "abd".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("1") {
                let tokenizer = TerminalTokenizer(terminal: "aaa")
                
                let actualStates = "aaab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
        }
    }
}