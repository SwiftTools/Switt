import Quick
import Nimble
@testable import Switt

private extension TokenInputOutputStream {
    func putHidden() {
        putToken(
            Token(
                string: "hidden",
                ruleIdentifier: RuleIdentifier.Unnamed("hidden"),
                channel: .Hidden,
                source: TokenSource(
                    stream: self,
                    position: positionForIndex(tokens.count)
                )
            )
        )
    }
    func putDefault(string: String) {
        putToken(
            Token(
                string: string,
                ruleIdentifier: RuleIdentifier.Unnamed("default"),
                channel: .Default,
                source: TokenSource(
                    stream: self,
                    position: positionForIndex(tokens.count)
                )
            )
        )
    }
}

class FilteredTokenInputStreamTests: QuickSpec {
    override func spec() {
        describe("FilteredTokenInputStream") {
            it("") {
                let inputStream = TokenInputOutputStream()
                inputStream.putHidden()
                inputStream.putDefault("1")
                inputStream.putHidden()
                inputStream.putDefault("2")
                inputStream.putDefault("3")
                
                let filteredStream = FilteredTokenInputStream(
                    stream: inputStream,
                    channel: .Default
                )
                
                expect(filteredStream.tokens.map { $0.string }).to(equal(["1", "2", "3"]))
            }
            
            it("") {
                let inputStream = TokenInputOutputStream()
                inputStream.putHidden()
                inputStream.putDefault("1")
                inputStream.putHidden()
                
                expect(inputStream.defaultChannel().token()?.string).to(equal("1"))
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
                expect(inputStream.defaultChannel().token()?.string).to(equal("1"))
            }
            
            it("") {
                let inputStream = TokenInputOutputStream()
                inputStream.putHidden()
                
                let position = inputStream.position
                let _ = inputStream.token()
                
                expect(inputStream.position).to(equal(position))
            }
            
            it("") {
                let inputStream = TokenInputOutputStream()
                inputStream.putHidden()
                inputStream.putDefault("1")
                inputStream.putHidden()
                
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
                expect(inputStream.defaultChannel().token()?.string).to(equal("1"))
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
            }
            
            it("") {
                let inputStream = TokenInputOutputStream()
                inputStream.putDefault("1")
                inputStream.putHidden()
                inputStream.putDefault("2")
                inputStream.putHidden()
                inputStream.putDefault("3")
                
                inputStream.moveNext()
                
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
                expect(inputStream.defaultChannel().token()?.string).to(equal("2"))
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
                
                inputStream.moveNext()
                
                expect(inputStream.defaultChannel().token()?.string).to(equal("2"))
                expect(inputStream.token()?.string).to(equal("2"))
                
                inputStream.moveNext()
                
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
                expect(inputStream.defaultChannel().token()?.string).to(equal("3"))
                expect(inputStream.token()?.channel).to(equal(TokenChannel.Hidden))
            }
            
            it("") {
                let inputStream = TokenInputOutputStream()
                
                inputStream.putHidden()
                inputStream.putDefault("1")
                inputStream.putHidden()
                inputStream.putDefault("2")
                inputStream.putDefault("3")
                
                expect(inputStream.defaultChannel().tokens.map { $0.string }).to(equal(["1", "2", "3"]))
                
                inputStream.moveNext()
                
                expect(inputStream.defaultChannel().tokens.map { $0.string }).to(equal(["1", "2", "3"]))
                
                inputStream.moveNext()
                
                expect(inputStream.defaultChannel().tokens.map { $0.string }).to(equal(["2", "3"]))
                
                inputStream.moveNext()
                
                expect(inputStream.defaultChannel().tokens.map { $0.string }).to(equal(["2", "3"]))
                
                inputStream.moveNext()
                
                expect(inputStream.defaultChannel().tokens.map { $0.string }).to(equal(["3"]))
                
                inputStream.moveNext()
                
                expect(inputStream.defaultChannel().tokens.map { $0.string }).to(equal([]))
                
                
                expect(inputStream.defaultChannel().tokenAt(-1)?.string).to(equal("3"))
                expect(inputStream.defaultChannel().tokenAt(-2)?.string).to(equal("2"))
                expect(inputStream.defaultChannel().tokenAt(-3)?.string).to(equal("1"))
                expect(inputStream.defaultChannel().tokenAt(-4)?.string).to(beNil()) 
            }
        }
    }
}