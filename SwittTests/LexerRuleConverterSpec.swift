import Quick
import Nimble
@testable import Switt

extension LexerRule {
    var alternatives: [LexerRule]? {
        switch self {
        case .Alternatives(let rules):
            return rules
        default:
            return nil
        }
    }
    
    var sequence: [LexerRule]? {
        switch self {
        case .Sequence(let rules):
            return rules
        default:
            return nil
        }
    }
    
    var ranges: [CharRange]? {
        switch self {
        case .Char(let ranges, _):
            return ranges
        default:
            return nil
        }
    }
    
    var invert: Bool? {
        switch self {
        case .Char(_, let invert):
            return invert
        default:
            return nil
        }
    }
    
    var ruleName: RuleName? {
        switch self {
        case .RuleReference(let ruleName):
            return ruleName
        default:
            return nil
        }
    }
    
    var terminal: String? {
        switch self {
        case .Terminal(let terminal):
            return terminal
        default:
            return nil
        }
    }
    
    var repetition: LexerRule? {
        switch self {
        case .Repetition(let rule):
            return rule
        default:
            return nil
        }
    }
}

extension ProductionRule {
    var alternatives: [ProductionRule]? {
        switch self {
        case .Alternatives(let rules):
            return rules
        default:
            return nil
        }
    }
    
    var sequence: [ProductionRule]? {
        switch self {
        case .Sequence(let rules):
            return rules
        default:
            return nil
        }
    }
    
    var ranges: [CharRange]? {
        switch self {
        case .Char(let ranges, _):
            return ranges
        default:
            return nil
        }
    }
    
    var invert: Bool? {
        switch self {
        case .Char(_, let invert):
            return invert
        default:
            return nil
        }
    }
    
    var ruleName: RuleName? {
        switch self {
        case .RuleReference(let ruleName):
            return ruleName
        default:
            return nil
        }
    }
    
    var terminal: String? {
        switch self {
        case .Terminal(let terminal):
            return terminal
        default:
            return nil
        }
    }
}

class LexerRuleConverterTests: XCTestCase, GrammarRulesBuilder {
    
    func test_convertToLexerRule_0() {
        let actualRule = LexerRuleConverter.convertToLexerRule(
            any(
                required("a"),
                compound(
                    required("b"),
                    any(
                        optional("c"),
                        zeroOrMore("d")
                    )
                )
            )
        )
        
        expect(actualRule?.alternatives).toNot(beNil())
    }
    
    func test_simplifyRule_0() {
        let actualRule = LexerRuleConverter.simplifyRule(
            ~"a" | "b" ~ (??"c" | zeroOrMore("d"))
        )
        
        expect(actualRule?.alternatives).toNot(beNil())
    }
    
    func test_simplifyRule_1() {
        let actualRule = LexerRuleConverter.simplifyRule(
            any("a", "b")
        )
        
        let expectedRule = any("a", "b")
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_simplifyRule_2() {
        let actualRule = LexerRuleConverter.simplifyRule(
            compound(
                required("x"),
                any("a", "b")
            )
        )
        
        let expectedRule = any(
            compound("x", "a"),
            compound("x", "b")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_simplifyRule_3() {
        let actualRule = LexerRuleConverter.simplifyRule(
            compound(
                required("x"),
                zeroOrMore("y")
            )
        )
        
        let expectedRule = any(
            compound(
                required("x"),
                oneOrMore("y")
            ),
            required("x")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_simplifyRule_4() {
        let actualRule = LexerRuleConverter.simplifyRule(
            compound(
                required("a"),
                any(
                    optional("b"),
                    zeroOrMore("c")
                )
            )
        )
        // a b? | a c*
        // a b | a | a c+ | a
        
        let expectedRule = any(
            compound(
                required("a"),
                required("b")
            ),
            required("a"),
            compound(
                required("a"),
                oneOrMore("c")
            ),
            required("a")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_stripMultiples_0() {
        let actualRule = LexerRuleConverter.stripMultiples(
            compound(
                required("a"),
                any(
                    optional("b"),
                    zeroOrMore("c")
                )
            )
        )
        
        // Rule is same: can't strip multiples
        let expectedRule = compound(
            required("a"),
            any(
                optional("b"),
                zeroOrMore("c")
            )
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_stripMultiples_1() {
        let actualRule = LexerRuleConverter.stripMultiples(
            any(
                compound(
                    required("a"),
                    optional("b")
                ),
                compound(
                    required("a"),
                    zeroOrMore("c")
                )
            )
        )
        
        let expectedRule = any(
            compound(
                required("a"),
                optional("b")
            ),
            any(
                compound(
                    required("a"),
                    oneOrMore("c")
                ),
                required("a")
            )
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_stripOptionals_1() {
        let actualRule = LexerRuleConverter.stripOptionals(
            compound(
                required("a"),
                any(
                    optional("b"),
                    zeroOrMore("c")
                )
            )
        )
        
        // Rule is same: can't strip optionals
        let expectedRule = compound(
            required("a"),
            any(
                optional("b"),
                zeroOrMore("c")
            )
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_splitAlternatives_0() {
        let actualRule = LexerRuleConverter.splitAlternatives(
            rulesBefore: [~"x"],
            alternatives: [[~"a"], [~"b"]],
            rulesAfter: [~"y"]
        )
        
        let expectedRule = any(
            compound("x", "a", "y"),
            compound("x", "b", "y")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_splitAlternatives_1() {
        let actualRule = LexerRuleConverter.splitAlternatives(
            rulesBefore: [~"x"],
            alternatives: [],
            rulesAfter: [~"y"]
        )
        
        let expectedRule = any([])
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_splitOptional_0() {
        let actualRule = LexerRuleConverter.splitOptional(
            rulesBefore: [~"x"],
            optional: ~"a",
            rulesAfter: [~"y"]
        )
        
        let expectedRule = any(
            compound("x", "a", "y"),
            compound("x", "y")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_stripOptionals_0() {
        let actualRule = LexerRuleConverter.stripOptionals(
            compound(
                required("x"),
                optional("a"),
                required("y")
            )
        )
        
        let expectedRule = any(
            compound("x", "a", "y"),
            compound("x", "y")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_mergeCollections_0() {
        let actualRule = LexerRuleConverter.mergeCollections(
            compound(
                compound("a"),
                compound("b"),
                compound("c")
            )
        )
        
        let expectedRule = compound("a", "b", "c")
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_mergeCollections_1() {
        let actualRule = LexerRuleConverter.mergeCollections(
            any(
                any("a"),
                any("b"),
                any("c")
            )
        )
        
        let expectedRule = any("a", "b", "c")
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_unrollSequence_0() {
        let actualRule = LexerRuleConverter.unrollSequence(
            [
                required("a"),
                any("b", "c")
            ]
        )
        
        let expectedRule = any(
            compound("a", "b"),
            compound("a", "c")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_unrollSequence_1() {
        let actualRule = LexerRuleConverter.unrollSequence(
            compound(
                required("a"),
                any("b", "c")
            )
        )
        
        let expectedRule = any(
            compound("a", "b"),
            compound("a", "c")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_unrollSequence_2() {
        let actualRule = LexerRuleConverter.unrollSequence(
            compound(
                required("a"),
                any(
                    optional("b"),
                    zeroOrMore("c")
                )
            )
        )
        
        let expectedRule = any(
            compound(
                required("a"),
                optional("b")
            ),
            compound(
                required("a"),
                zeroOrMore("c")
            )
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_mergeCollections_2() {
        let actualRule = LexerRuleConverter.mergeCollections(
            compound(
                required("a"),
                any(
                    optional("b"),
                    zeroOrMore("c")
                )
            )
        )
        
        // Can't merge collections
        let expectedRule = compound(
            required("a"),
            any(
                optional("b"),
                zeroOrMore("c")
            )
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_removeUnusedEmptys_0() {
        let actualRule = LexerRuleConverter.removeUnusedEmptys(
            compound(
                empty(),
                required("a"),
                empty(),
                required("b"),
                empty()
            )
        )
        
        let expectedRule = compound("a", "b")
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_removeUnusedEmptys_1() {
        let actualRule = LexerRuleConverter.removeUnusedEmptys(
            compound(
                empty(),
                required("a"),
                any(
                    required("x"),
                    empty(),
                    required("y")
                ),
                compound(
                    empty(),
                    required("b"),
                    empty(),
                    required("c"),
                    empty()
                ),
                empty()
            )
        )
        
        let expectedRule = compound(
            required("a"),
            empty(),
            compound("b", "c")
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
    
    func test_removeUnusedEmptys_2() {
        let actualRule = LexerRuleConverter.removeUnusedEmptys(
            compound(
                required("a"),
                any(
                    optional("b"),
                    zeroOrMore("c")
                )
            )
        )
        
        // Can't remove emptys
        let expectedRule = compound(
            required("a"),
            any(
                optional("b"),
                zeroOrMore("c")
            )
        )
        
        expect(actualRule).to(equal(expectedRule))
    }
}