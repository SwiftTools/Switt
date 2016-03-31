import XCTest
import Nimble
@testable import Switt

class ProtocolDeclarationGrammarTests: XCTestCase {
    func test() {
        let helper = LexicalAnalysisTestHelper()
        let code = "//\n"
            + "// Copyright (c) 2016 Switt contributors\n"
            + "// This program is made available under the terms of the MIT License.\n"
            + "//\n"
            + "\n"
            + "protocol CustomTokenParserFactory: class {\n"
            + "var involvedTerminals: [String] { get }\n"
            + "func tokenParser(tokenParserFactory: TokenParserFactory, parserRuleConverter: ParserRuleConverter) -> TokenParser\n"
            + "}"
        let tokens = helper.tokenize(code)
        expect(helper.isSuccess(code, firstRule: RuleName.protocol_declaration)).to(beTrue())
    }
}