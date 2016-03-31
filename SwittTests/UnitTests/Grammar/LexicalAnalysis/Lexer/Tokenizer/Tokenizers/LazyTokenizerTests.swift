import Quick
import Nimble
@testable import Switt

private class Helper {
    static func tokenizer(start start: String, rule: String, stop: String) -> LazyTokenizer {
        var lexerRules = LexerRules()
        
        lexerRules.appendRule(terminal: start, rule: LexerRule.Terminal(terminal: start))
        lexerRules.appendRule(terminal: rule, rule: LexerRule.Terminal(terminal: rule))
        lexerRules.appendRule(terminal: stop, rule: LexerRule.Terminal(terminal: stop))
        
        let tokenizerFactory = TokenizerFactoryImpl(lexerRules: lexerRules)
        
        let tokenizer = LazyTokenizer(
            startRule: LexerRule.Terminal(terminal: start),
            rule: LexerRule.Terminal(terminal: rule),
            stopRule: LexerRule.Terminal(terminal: stop),
            tokenizerFactory: tokenizerFactory
        )
        
        return tokenizer
    }
}

class LazyTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("LazyTokenizer") {
            it("1") {
                let tokenizer = Helper.tokenizer(start: "a", rule: "bc", stop: "cd")
                
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
                let tokenizer = Helper.tokenizer(start: "a", rule: "bc", stop: "cd")
                
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
                let tokenizer = Helper.tokenizer(start: "a", rule: "bc", stop: "cd")
                
                let actualStates = "abcbccde".characters.map { tokenizer.feed($0) }
                let expectedStates = [
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
                let tokenizer = Helper.tokenizer(start: "a", rule: "b", stop: "c")
                
                let actualStates = "abcb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("5") {
                let tokenizer = Helper.tokenizer(start: "a", rule: "b", stop: "c")
                
                let actualStates = "abbcb".characters.map { tokenizer.feed($0) }
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
                let tokenizer = Helper.tokenizer(start: "aa", rule: "b", stop: "c")
                
                let actualStates = "aacb".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("7") {
                let tokenizer = Helper.tokenizer(start: "a", rule: "b", stop: "c")
                
                let actualStates = "aca".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Possible,
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            
            it("8") {
                let tokenizer = Helper.tokenizer(start: "a", rule: "b", stop: "c")
                
                let actualStates = "c".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
        }
    }
}