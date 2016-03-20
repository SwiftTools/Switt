import XCTest
import Nimble
@testable import Switt

class LexicalAnalysisIdentifierTests: XCTestCase {
    func test() {
        let helper = LexicalAnalysisTestHelper()
        
        expect(helper.isSuccess("i", firstRule: RuleName.Identifier_head)).to(equal(true))
        expect(helper.isSuccess("1", firstRule: RuleName.Identifier_head)).to(equal(false))
        
        expect(helper.isSuccess("identifier", firstRule: RuleName.identifier)).to(equal(true))
        expect(helper.isSuccess("class", firstRule: RuleName.identifier)).to(equal(false))
        expect(helper.isSuccess("1", firstRule: RuleName.identifier)).to(equal(false))
        expect(helper.isSuccess("_", firstRule: RuleName.identifier)).to(equal(false))        
        
        expect(helper.isSuccess("1", firstRule: RuleName.integer_literal)).to(equal(true))
        expect(helper.isSuccess("1dstdasfadsf", firstRule: RuleName.integer_literal)).to(equal(false))
        expect(helper.isSuccess("1.0", firstRule: RuleName.integer_literal)).to(equal(false))
        expect(helper.isSuccess("\"1\"", firstRule: RuleName.integer_literal)).to(equal(false))
        
        expect(helper.isSuccess("true", firstRule: RuleName.boolean_literal)).to(equal(true))
        expect(helper.isSuccess("false", firstRule: RuleName.boolean_literal)).to(equal(true))
        expect(helper.isSuccess("0", firstRule: RuleName.boolean_literal)).to(equal(false))
        expect(helper.isSuccess("truee", firstRule: RuleName.boolean_literal)).to(equal(false))
        
        expect(helper.isSuccess("1.0", firstRule: RuleName.Floating_point_literal)).to(equal(true))
        expect(helper.isSuccess("1.0.0", firstRule: RuleName.Floating_point_literal)).to(equal(false))
        expect(helper.isSuccess("\"1\"", firstRule: RuleName.Floating_point_literal)).to(equal(false))
        
        expect(helper.isSuccess("MyClass", firstRule: RuleName.class_name)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile {}", firstRule: RuleName.class_declaration)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile {_}", firstRule: RuleName.class_declaration)).to(equal(false))
        
        // Expression is statement:
        expect(helper.isSuccess("1", firstRule: RuleName.statement)).to(equal(true))
        expect(helper.isSuccess("1 + 1", firstRule: RuleName.statement)).to(equal(true))
        expect(helper.isSuccess("x = 1", firstRule: RuleName.statement)).to(equal(true))
        expect(helper.isSuccess("var x = 1", firstRule: RuleName.statement)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { }", firstRule: RuleName.declaration)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile { }", firstRule: RuleName.declarations)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile { }", firstRule: RuleName.statement)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile { }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { let file: Int }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { let file = 1 }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file = 1 }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = \"\" }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = __FILE__ }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = __FILE__ } "
            + "class TestSwiftFileWithFunction { }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = __FILE__ } "
            + "class TestSwiftFileWithFunction { func doWork(a: Int, andB b: String) -> [String] { return [] } }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("x = 1", firstRule: RuleName.pattern_initializer)).to(equal(true))
        
        expect(helper.isSuccess("_", firstRule: RuleName.pattern)).to(equal(true))
        expect(helper.isSuccess("x", firstRule: RuleName.pattern)).to(equal(true))
        expect(helper.isSuccess("?", firstRule: RuleName.pattern)).to(equal(false))
        
        expect(helper.isSuccess("= 1", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess("= identifier", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess("=identifier", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess("=", firstRule: RuleName.assignment_operator)).to(equal(true))
        expect(helper.isSuccess("1", firstRule: RuleName.expression)).to(equal(true))
        
        
        expect(helper.isSuccess("? 1 :", firstRule: RuleName.conditional_operator)).to(equal(true))
        
        expect(helper.isSuccess("identifier", firstRule: RuleName.primary_expression)).to(equal(true))
        expect(helper.isSuccess("identifier", firstRule: RuleName.postfix_expression)).to(equal(true))
        expect(helper.isSuccess("&identifier", firstRule: RuleName.in_out_expression)).to(equal(true))
        
        expect(helper.isSuccess("try", firstRule: RuleName.try_operator)).to(equal(true))
        expect(helper.isSuccess("try!", firstRule: RuleName.try_operator)).to(equal(true))
        expect(helper.isSuccess("try?", firstRule: RuleName.try_operator)).to(equal(true))
        expect(helper.isSuccess("try$", firstRule: RuleName.try_operator)).to(equal(false))
        
        expect(helper.isSuccess("is Int", firstRule: RuleName.type_casting_operator)).to(equal(true))
        expect(helper.isSuccess("as Int", firstRule: RuleName.type_casting_operator)).to(equal(true))
        expect(helper.isSuccess("as? Int", firstRule: RuleName.type_casting_operator)).to(equal(true))
        expect(helper.isSuccess("as! Int", firstRule: RuleName.type_casting_operator)).to(equal(true))
        expect(helper.isSuccess("asInt", firstRule: RuleName.type_casting_operator)).to(equal(false))
        
        
        expect(helper.isSuccess("1", firstRule: RuleName.prefix_expression)).to(equal(true))
        
        expect(helper.isSuccess("1 + 1", firstRule: RuleName.binary_expression)).to(equal(true))
    }
}