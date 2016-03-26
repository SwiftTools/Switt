import XCTest
import Nimble
@testable import Switt

class LexerRulesTests: XCTestCase {
    func testThatEachTerminalIsAddedOnlyOnceToGrammar() {
        var lexerRules = LexerRules()
        lexerRules.appendRule(terminal: ",", rule: LexerRule.Terminal(terminal: ","))
        lexerRules.appendRule(terminal: ",", rule: LexerRule.Terminal(terminal: ","))
        
        expect(lexerRules.rules.count).to(equal(1))
        expect(lexerRules.rulesByName.count).to(equal(0))
        expect(lexerRules.fragmentsByName.count).to(equal(0))
    }
}