import Quick
import Nimble
@testable import Switt

private class Helper {
    static func tokenizer(rule: LexerRule) -> RepetitionTokenizer {
        let tokenizerFactory = TokenizerFactoryImpl(lexerRules: LexerRules())
        
        let tokenizer = RepetitionTokenizer(
            rule: rule,
            tokenizerFactory: tokenizerFactory
        )
        
        return tokenizer
    }
}

class RepetitionTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("RepetitionTokenizer") {
            it("1") {
                let tokenizer = Helper.tokenizer(
                    LexerRule.Terminal(terminal: "a")
                )
                
                let actualStates = "ab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("1") {
                let tokenizer = Helper.tokenizer(
                    LexerRule.Terminal(terminal: "aa")
                )
                
                let actualStates = "aab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("2") {
                let tokenizer = Helper.tokenizer(
                    LexerRule.Terminal(terminal: "a")
                )
                
                let actualStates = "aab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("3") {
                let tokenizer = Helper.tokenizer(
                    LexerRule.Terminal(terminal: "a")
                )
                
                let actualStates = "aaab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Complete,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("4") {
                let tokenizer = Helper.tokenizer(
                    LexerRule.Terminal(terminal: "aa")
                )
                
                let actualStates = "aaaaab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Possible,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("5") {
                let tokenizer = Helper.tokenizer(
                    LexerRule.Terminal(terminal: "aa")
                )
                
                let actualStates = "aaaab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
        }
    }
}