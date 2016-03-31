import XCTest
import Nimble
@testable import Switt
 
class BlockCommentGrammarTests: XCTestCase {
    func test() {
        let helper = LexicalAnalysisTestHelper()
        
        expect(helper.tokenIdentifiers("/**/"))
            .to(equal([RuleIdentifier.Named(.Block_comment)]))
        
        expect(helper.tokenIdentifiers("/*/**/*/"))
            .to(equal([RuleIdentifier.Named(.Block_comment)]))
        
        expect(helper.tokenIdentifiers("/*a*/"))
            .to(equal([RuleIdentifier.Named(.Block_comment)]))
        
        expect(helper.tokenIdentifiers("/*ababab*/"))
            .to(equal([RuleIdentifier.Named(.Block_comment)]))
        
        expect(helper.tokenIdentifiers("/*/*/*/*/*/*/*/**/*/*/*/*/*/*/*/"))
            .to(equal([RuleIdentifier.Named(.Block_comment)]))
        
        expect(helper.tokenIdentifiers("/**//**/"))
            .to(equal([RuleIdentifier.Named(.Block_comment), RuleIdentifier.Named(.Block_comment)]))
        
        // Errors:
        expect(helper.tokenIdentifiers("/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/ inside unterminated comment"))
            .to(equal([]))
        
        expect(helper.tokenIdentifiers("/*/")).to(equal([]))
        expect(helper.tokenIdentifiers("/*/*/")).to(equal([]))
        
        // Fails:
        expect(helper.tokenIdentifiers("/ * */"))
            .toNot(equal([RuleIdentifier.Named(.Block_comment)]))
        
    }
}