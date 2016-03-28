import Quick
import Nimble
@testable import Switt

class FilteredTokenInputStreamTests: QuickSpec {
    override func spec() {
        describe("FilteredTokenInputStream") {
            it("") {
                let inputStream = TokenInputOutputStream()
                inputStream.putToken(
                    Token(
                        string: "hidden",
                        ruleIdentifier: RuleIdentifier.Unnamed("hidden"),
                        channel: .Hidden
                    )
                )
                inputStream.putToken(
                    Token(
                        string: "1",
                        ruleIdentifier: RuleIdentifier.Unnamed("default"),
                        channel: .Default
                    )
                )
                inputStream.putToken(
                    Token(
                        string: "hidden",
                        ruleIdentifier: RuleIdentifier.Unnamed("hidden"),
                        channel: .Hidden
                    )
                )
                inputStream.putToken(
                    Token(
                        string: "2",
                        ruleIdentifier: RuleIdentifier.Unnamed("default"),
                        channel: .Default
                    )
                )
                inputStream.putToken(
                    Token(
                        string: "3",
                        ruleIdentifier: RuleIdentifier.Unnamed("default"),
                        channel: .Default
                    )
                )
                
                let filteredStream = FilteredTokenInputStream(
                    stream: inputStream,
                    channel: .Default
                )
                
                expect(filteredStream.tokens.map { $0.string }).to(equal(["1", "2", "3"]))
            }
        }
    }
}