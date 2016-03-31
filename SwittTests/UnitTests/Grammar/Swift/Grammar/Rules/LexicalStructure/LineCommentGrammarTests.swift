import XCTest
import Nimble
@testable import Switt

class LineCommentGrammarTests: XCTestCase {
    func test() {
        let helper = LexicalAnalysisTestHelper()
        expect(helper.tokenize("//\n").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("///\n").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("//a\n").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("//abcd\n").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("//").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("///").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("//a").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
        expect(helper.tokenize("//abcd").map { $0.ruleIdentifier }).to(equal([RuleIdentifier.Named(.Line_comment)]))
    }
}