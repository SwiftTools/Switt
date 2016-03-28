import Quick
import Nimble
@testable import Switt

class TokenInputOutputStreamTests: QuickSpec {
    override func spec() {
        describe("TokenInputOutputStream") {
            it("") {
                let stream = TokenInputOutputStream()
                let startPosition = stream.position
                stream.putToken(
                    Token(
                        string: "1",
                        ruleIdentifier: RuleIdentifier.Unnamed("a"),
                        channel: .Default
                    )
                )
                stream.putToken(
                    Token(
                        string: "2",
                        ruleIdentifier: RuleIdentifier.Unnamed("b"),
                        channel: .Hidden
                    )
                )
                stream.putToken(
                    Token(
                        string: "3",
                        ruleIdentifier: RuleIdentifier.Unnamed("c"),
                        channel: .Default
                    )
                )
                
                expect(stream.getToken()?.string).to(equal("1"))
                expect(stream.getToken()?.ruleIdentifier).to(equal(RuleIdentifier.Unnamed("a")))
                expect(stream.getToken()?.channel).to(equal(LexerChannel.Default))
                
                stream.moveNext()
                let middlePosition = stream.position
                let middlePositionSame = stream.position
                
                expect(middlePosition).to(equal(middlePositionSame))
                expect(middlePosition).to(beGreaterThan(startPosition))
                expect(middlePositionSame).to(beGreaterThan(startPosition))
                expect(startPosition).to(equal(startPosition))
                
                expect(stream.getToken()?.string).to(equal("2"))
                expect(stream.getToken()?.ruleIdentifier).to(equal(RuleIdentifier.Unnamed("b")))
                expect(stream.getToken()?.channel).to(equal(LexerChannel.Hidden))
                
                stream.moveNext()
                let endPosition = stream.position
                
                expect(stream.getToken()?.string).to(equal("3"))
                expect(stream.getToken()?.ruleIdentifier).to(equal(RuleIdentifier.Unnamed("c")))
                expect(stream.getToken()?.channel).to(equal(LexerChannel.Default))
                
                expect(endPosition).to(beGreaterThan(startPosition))
                expect(endPosition).to(beGreaterThan(middlePosition))
                expect(endPosition).to(beGreaterThanOrEqualTo(startPosition))
                expect(endPosition).to(beGreaterThanOrEqualTo(middlePosition))
                
                expect(startPosition).to(beLessThan(endPosition))
                expect(startPosition).to(beLessThan(middlePosition))
                expect(startPosition).to(beLessThanOrEqualTo(endPosition))
                expect(startPosition).to(beLessThanOrEqualTo(middlePosition))
                
                expect(middlePosition).to(beLessThan(endPosition))
                expect(middlePosition).to(beLessThanOrEqualTo(endPosition))
                expect(middlePosition).to(beGreaterThan(startPosition))
                expect(middlePosition).to(beGreaterThanOrEqualTo(startPosition))
                
                startPosition.restore()
                // Nothing should change:
                
                expect(endPosition).to(beGreaterThan(startPosition))
                expect(endPosition).to(beGreaterThan(middlePosition))
                expect(endPosition).to(beGreaterThanOrEqualTo(startPosition))
                expect(endPosition).to(beGreaterThanOrEqualTo(middlePosition))
                
                expect(startPosition).to(beLessThan(endPosition))
                expect(startPosition).to(beLessThan(middlePosition))
                expect(startPosition).to(beLessThanOrEqualTo(endPosition))
                expect(startPosition).to(beLessThanOrEqualTo(middlePosition))
                
                expect(middlePosition).to(beLessThan(endPosition))
                expect(middlePosition).to(beLessThanOrEqualTo(endPosition))
                expect(middlePosition).to(beGreaterThan(startPosition))
                expect(middlePosition).to(beGreaterThanOrEqualTo(startPosition))
            }
        }
    }
    
}