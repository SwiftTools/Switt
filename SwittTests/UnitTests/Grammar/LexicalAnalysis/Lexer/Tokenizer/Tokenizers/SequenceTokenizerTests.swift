import Quick
import Nimble
@testable import Switt

private class Helper {
    static func tokenizer(rules: [LexerRule]) -> SequenceTokenizer {
        let tokenizer = SequenceTokenizer(
            rules: rules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: LexerRules())
        )
            
        return tokenizer
    }
}


class SequenceTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("SequenceTokenizer") {
            it("1") {
                let tokenizer = Helper.tokenizer(
                    [
                        LexerRule.Terminal(terminal: "a"),
                        LexerRule.Terminal(terminal: "b")
                    ]
                )
                let actualStates = "abc".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("2") {
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
            
            it("2") {
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