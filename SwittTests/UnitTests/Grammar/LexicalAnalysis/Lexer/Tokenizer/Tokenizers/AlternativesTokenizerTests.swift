import Quick
import Nimble
@testable import Switt

private class Helper {
    static func tokenizer(rules: [LexerRule]) -> AlternativesTokenizer {
        let tokenizer = AlternativesTokenizer(
            rules: rules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: LexerRules())
        )
        
        return tokenizer
    }
}

class AlternativesTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("AlternativesTokenizer") {
            it("mismatches token if all rules are mismatched, with matching token later in sequence") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "aa"),
                        LexerRule.Terminal(terminal: "bb")
                    ]
                )
                let actualStates = "abb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Fail,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("matches token if one of rules matches (e.g.: first)") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "aa"),
                        LexerRule.Terminal(terminal: "bb")
                    ]
                )
                let actualStates = "aabb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("matches token if one of rules matches (e.g.: second)") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "bb"),
                        LexerRule.Terminal(terminal: "aa")
                    ]
                )
                let actualStates = "aabb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("mismatches token if all rules are mismatched") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "aa"),
                        LexerRule.Terminal(terminal: "bb")
                    ]
                )
                let actualStates = "bab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Fail,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("mismatches token if all rules are mismatched, if there is only one rule of 1 char") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "a")
                    ]
                )
                let actualStates = "ab".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("mismatches token if all rules are mismatched, if there is only one rule of several chars") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "aaa")
                    ]
                )
                let actualStates = "aaaa".characters.map { tokenizer.feed($0) }
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