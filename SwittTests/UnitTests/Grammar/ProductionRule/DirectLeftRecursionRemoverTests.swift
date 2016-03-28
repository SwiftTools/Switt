import Quick
import Nimble
@testable import Switt

private class Helper {
    static func parser(rules rules: [ParserRule]) -> TokenParser {
        let parser = AlternativesTokenParser(
            rules: rules,
            tokenParserFactory: TokenParserFactoryImpl(
                parserRules: ParserRules()
            )
        )
        return parser
    }
}

class DirectLeftRecursionRemoverTests: QuickSpec {
    override func spec() {
        describe("AlternativesTokenParser") {
            it("") {
                let remover = DirectLeftRecursionRemoverImpl()
                let parserRuleRegistrationInfo = ParserRuleRegistrationInfo(
                    name: .expression,
                    rule: ProductionRule.Alternatives(
                        rules: [
                            ProductionRule.Sequence(
                                rules: [
                                    ProductionRule.RuleReference(identifier: RuleIdentifier.Named(.expression)),
                                    ProductionRule.Terminal(terminal: "+"),
                                    ProductionRule.RuleReference(identifier: RuleIdentifier.Named(.expression))
                                ]
                            ),
                            ProductionRule.Sequence(
                                rules: [
                                    ProductionRule.RuleReference(identifier: RuleIdentifier.Named(.expression)),
                                    ProductionRule.Terminal(terminal: "-"),
                                    ProductionRule.RuleReference(identifier: RuleIdentifier.Named(.expression))
                                ]
                            ),
                            ProductionRule.Sequence(
                                rules: [
                                    ProductionRule.Terminal(terminal: "1")
                                ]
                            ),
                            ProductionRule.Terminal(terminal: "0")
                        ]
                    )
                )
                let rules = remover.removeDirectLeftRecursion(parserRuleRegistrationInfo)
                
                expect(rules.count).to(equal(2))
                
                guard let firstInfo = rules.at(0), secondInfo = rules.at(1) else {
                    fail("")
                    return
                }
                
                let parserRuleInfoOpt: ParserRuleRegistrationInfo?
                let parserFragmentInfoOpt: ParserFragmentRegistrationInfo?
                
                switch firstInfo {
                case .ParserRule(let info):
                    parserRuleInfoOpt = info
                default:
                    parserRuleInfoOpt = nil
                }
                
                switch secondInfo {
                case .ParserFragment(let info):
                    parserFragmentInfoOpt = info
                default:
                    parserFragmentInfoOpt = nil
                }
                
                guard let parserRuleInfo = parserRuleInfoOpt, let parserFragmentInfo = parserFragmentInfoOpt else {
                    fail("")
                    return
                }
                
                let expectedRule = ProductionRule.Alternatives(
                    rules: [
                        ProductionRule.Sequence(
                            rules: [
                                ProductionRule.Terminal(terminal: "1"),
                                ProductionRule.RuleReference(identifier: parserFragmentInfo.identifier)
                            ]
                        ),
                        ProductionRule.Sequence(
                            rules: [
                                ProductionRule.Terminal(terminal: "0"),
                                ProductionRule.RuleReference(identifier: parserFragmentInfo.identifier)
                            ]
                        )
                    ]
                )
                let expectedFragment = ProductionRule.Alternatives(
                    rules: [
                        ProductionRule.Sequence(
                            rules: [
                                ProductionRule.Terminal(terminal: "+"),
                                ProductionRule.RuleReference(identifier: RuleIdentifier.Named(.expression)),
                                ProductionRule.RuleReference(identifier: parserFragmentInfo.identifier)
                            ]
                        ),
                        ProductionRule.Sequence(
                            rules: [
                                ProductionRule.Terminal(terminal: "-"),
                                ProductionRule.RuleReference(identifier: RuleIdentifier.Named(.expression)),
                                ProductionRule.RuleReference(identifier: parserFragmentInfo.identifier)
                            ]
                        ),
                        ProductionRule.Empty
                    ]
                )
                
                expect(parserRuleInfo.rule).to(equal(expectedRule))
                expect(parserRuleInfo.name).to(equal(RuleName.expression))
                expect(parserFragmentInfo.rule).to(equal(expectedFragment))
            }
        }
    }
}