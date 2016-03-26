import Quick
import Nimble
@testable import Switt

private class Helper {
    static func tokenizer(rule rule: String, stop: String, required: Bool) -> LazyTokenizer {
        var lexerRules = LexerRules()
        
        lexerRules.appendRule(terminal: rule, rule: LexerRule.Terminal(terminal: rule))
        lexerRules.appendRule(terminal: stop, rule: LexerRule.Terminal(terminal: stop))
        
        let tokenizerFactory = TokenizerFactoryImpl(lexerRules: lexerRules)
        
        let tokenizer = LazyTokenizer(
            rule: LexerRule.Terminal(terminal: rule),
            stopRule: LexerRule.Terminal(terminal: stop),
            stopRuleIsRequired: required,
            tokenizerFactory: tokenizerFactory
        )
        
        return tokenizer
    }
}

class LazyTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("LazyTokenizer") {
            it("1") {
                let tokenizer = Helper.tokenizer(rule: "abc", stop: "cd", required: true)
                
                let actualStates = "abccdc".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                    ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("2") {
                let tokenizer = Helper.tokenizer(rule: "abc", stop: "cd", required: true)
                
                let actualStates = "abcd".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("3") {
                let tokenizer = Helper.tokenizer(rule: "abc", stop: "cd", required: true)
                
                let actualStates = "abcabccde".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("4") {
                let tokenizer = Helper.tokenizer(rule: "a", stop: "b", required: true)
                
                let actualStates = "abb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("5") {
                let tokenizer = Helper.tokenizer(rule: "a", stop: "b", required: true)
                
                let actualStates = "aaaba".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("6") {
                let tokenizer = Helper.tokenizer(rule: "a", stop: "b", required: false)
                
                let actualStates = "aaaba".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Complete,
                    TokenizerState.Complete,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("7") {
                let tokenizer = Helper.tokenizer(rule: "a", stop: "b", required: false)
                
                let actualStates = "ba".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("8") {
                let tokenizer = Helper.tokenizer(rule: "a", stop: "b", required: false)
                
                let actualStates = "c".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("9") {
                let tokenizer = Helper.tokenizer(rule: "a", stop: "b", required: false)
                
                let actualStates = "bb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
        }
    }
}