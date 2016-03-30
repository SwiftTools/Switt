import XCTest
import Nimble
@testable import Switt

class LexicalAnalysisIdentifierTests: XCTestCase {
    func test() {
        let helper = LexicalAnalysisTestHelper()
        
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
        
        expect(helper.isSuccess("class TestSwiftFile { static var file: String? }", firstRule: RuleName.statements)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile { static var file: String? = nil }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = \"\" }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = __FILE__ }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = __FILE__ } "
            + "class TestSwiftFileWithFunction { }", firstRule: RuleName.statements)).to(equal(true))
        expect(helper.isSuccess("class TestSwiftFile { static lds sd sD sdljfB; BUfuO~Q*:U3Y(IPTHILfkhfl sa// / // /et file: String = __FILE__ } "
            + "class TestSwiftFileWithFunction { }", firstRule: RuleName.statements)).to(equal(false))
        
        expect(helper.isSuccess("class TestSwiftFile { static let file: String = __FILE__ } "
            + "class TestSwiftFileWithFunction { func doWork(a: Int, andB b: String) -> [String] { return [] } }", firstRule: RuleName.statements)).to(equal(true))
        
        expect(helper.isSuccess("class TestSwiftFileWithFunction { func doWork(a: Int, andB b: String) -> [String] { return [] } }", firstRule: RuleName.class_declaration)).to(equal(true))
        
        expect(helper.isSuccess("{ func doWork(a: Int, andB b: String) -> [String] { return [] } }", firstRule: RuleName.class_body)).to(equal(true))
        expect(helper.isSuccess("func doWork(a: Int, andB b: String) -> [String] { return [] }", firstRule: RuleName.declarations)).to(equal(true))
        expect(helper.isSuccess("func doWork(a: Int, andB b: String) -> [String] { return [] }", firstRule: RuleName.function_declaration)).to(equal(true))
        
        expect(helper.isSuccess("func", firstRule: RuleName.function_head)).to(equal(true))
        expect(helper.isSuccess("doWork", firstRule: RuleName.function_name)).to(equal(true))
        expect(helper.isSuccess("<T>", firstRule: RuleName.generic_parameter_clause)).to(equal(true))
        expect(helper.isSuccess("(a: Int, andB b: String) -> [String]", firstRule: RuleName.function_signature)).to(equal(true))
        expect(helper.isSuccess("{ return [] }", firstRule: RuleName.function_body)).to(equal(true))
        
        expect(helper.isSuccess("(a: Int, andB b: String)", firstRule: RuleName.parameter_clauses)).to(equal(true))
        expect(helper.isSuccess(" -> [String]", firstRule: RuleName.function_result)).to(equal(true))
        
        expect(helper.isSuccess("a: Int", firstRule: RuleName.parameter)).to(equal(true))
        expect(helper.isSuccess("andB b: String", firstRule: RuleName.parameter)).to(equal(true))
        
        
        expect(helper.isSuccess("andB", firstRule: RuleName.external_parameter_name)).to(equal(true))
        expect(helper.isSuccess("b", firstRule: RuleName.local_parameter_name)).to(equal(true))
        expect(helper.isSuccess(": String", firstRule: RuleName.type_annotation)).to(equal(true))
        expect(helper.isSuccess(" = 1", firstRule: RuleName.default_argument_clause)).to(equal(true))
        /*
         
         optional(.external_parameter_name),
         required(.local_parameter_name),
         optional(.type_annotation),
         optional(.default_argument_clause)
         */

        expect(helper.isSuccess("x = 1", firstRule: RuleName.pattern_initializer)).to(equal(true))
        
        expect(helper.isSuccess("_", firstRule: RuleName.pattern)).to(equal(true))
        expect(helper.isSuccess("x", firstRule: RuleName.pattern)).to(equal(true))
        expect(helper.isSuccess("?", firstRule: RuleName.pattern)).to(equal(false))
        
        expect(helper.isSuccess(" = 1", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess(" = 1", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess(" = identifier", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess(" = identifier", firstRule: RuleName.initializer)).to(equal(true))
        expect(helper.isSuccess(" = ", firstRule: RuleName.assignment_operator)).to(equal(true))
        expect(helper.isSuccess("1", firstRule: RuleName.expression)).to(equal(true))
        
        
        expect(helper.isSuccess("? 1 :", firstRule: RuleName.conditional_operator)).to(equal(true))
        
        expect(helper.isSuccess("identifier", firstRule: RuleName.primary_expression)).to(equal(true))
        
        expect(helper.isSuccess("identifier", firstRule: RuleName.postfix_expression)).to(equal(true))
        expect(helper.isSuccess("identifier[1]", firstRule: RuleName.postfix_expression)).to(equal(true))
        
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
        
        expect(helper.isSuccess(" + ", firstRule: RuleName.binary_operator)).to(equal(true))
        
        expect(helper.isSuccess("+", firstRule: RuleName._operator)).to(equal(true))
        expect(helper.isSuccess(" + ", firstRule: RuleName._operator)).to(equal(true))
        
        expect(helper.isSuccess(" + 1", firstRule: RuleName.binary_expression)).to(equal(true))
    }
}