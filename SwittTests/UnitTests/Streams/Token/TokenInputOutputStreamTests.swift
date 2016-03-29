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
                        channel: .Default,
                        source: TokenSource(
                            stream: stream,
                            position: stream.positionForIndex(stream.tokens.count)
                        )
                    )
                )
                stream.putToken(
                    Token(
                        string: "2",
                        ruleIdentifier: RuleIdentifier.Unnamed("b"),
                        channel: .Hidden,
                        source: TokenSource(
                            stream: stream,
                            position: stream.positionForIndex(stream.tokens.count)
                        )
                    )
                )
                stream.putToken(
                    Token(
                        string: "3",
                        ruleIdentifier: RuleIdentifier.Unnamed("c"),
                        channel: .Default,
                        source: TokenSource(
                            stream: stream,
                            position: stream.positionForIndex(stream.tokens.count)
                        )
                    )
                )
                
                expect(stream.token()?.string).to(equal("1"))
                expect(stream.token()?.ruleIdentifier).to(equal(RuleIdentifier.Unnamed("a")))
                expect(stream.token()?.channel).to(equal(TokenChannel.Default))
                
                stream.moveNext()
                let middlePosition = stream.position
                let middlePositionSame = stream.position
                
                expect(middlePosition).to(equal(middlePositionSame))
                expect(middlePosition).to(beGreaterThan(startPosition))
                expect(middlePositionSame).to(beGreaterThan(startPosition))
                expect(startPosition).to(equal(startPosition))
                
                expect(stream.token()?.string).to(equal("2"))
                expect(stream.token()?.ruleIdentifier).to(equal(RuleIdentifier.Unnamed("b")))
                expect(stream.token()?.channel).to(equal(TokenChannel.Hidden))
                
                stream.moveNext()
                let endPosition = stream.position
                
                expect(stream.token()?.string).to(equal("3"))
                expect(stream.token()?.ruleIdentifier).to(equal(RuleIdentifier.Unnamed("c")))
                expect(stream.token()?.channel).to(equal(TokenChannel.Default))
                
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