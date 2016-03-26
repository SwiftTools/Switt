import Quick
import Nimble
@testable import Switt

//private class Helper {
//    static func tokenizer(chars chars: String) -> CharTokenizer {
//        let tokenizer = CharTokenizer(charRanges: <#T##[CharRange]#>, invert: <#T##Bool#>)
//        return tokenizer
//    }
//    static func tokenizer(from from: Character, to: Character) -> CharTokenizer {
//        let tokenizer = CharTokenizer(charRanges: [CharRange], invert: <#T##Bool#>)
//        return tokenizer
//    }
//    static func tokenizer(chars chars: String) -> CharTokenizer {
//        let tokenizer = CharTokenizer(charRanges: <#T##[CharRange]#>, invert: <#T##Bool#>)
//        return tokenizer
//    }
//}
//

class CharTokenizerTests: QuickSpec, GrammarRulesBuilder {
    override func spec() {
        describe("SequenceTokenizer") {
            it("1") {
                let tokenizer = CharTokenizer(charRanges: [CharRange(char: "a")], invert: false)
                
                let actualStates = "aa".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            it("1") {
                let tokenizer = CharTokenizer(charRanges: [CharRange(first: "a", last: "z")], invert: false)
                
                let actualStates = "rr".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Complete,
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
            it("1") {
                let tokenizer = CharTokenizer(charRanges: [CharRange(first: "a", last: "z")], invert: false)
                
                let actualStates = "A".characters.map { tokenizer.feed($0) }
                let expectedStates = [
                    TokenizerState.Fail
                ]
                
                expect(actualStates).to(equal(expectedStates))
            }
        }
    }
}