@testable import Switt

protocol TokenConvertible {
    func convertToToken(tokenSource: TokenSource) -> Token
}

extension String: TokenConvertible {
    func convertToToken(tokenSource: TokenSource) -> Token {
        return Token(
            string: self,
            ruleIdentifier: RuleIdentifier.Unnamed(self),
            channel: .Default,
            source: tokenSource
        )
    }
}

extension Token: TokenConvertible {
    func convertToToken(tokenSource: TokenSource) -> Token {
        return self
    }
}

extension RuleName: TokenConvertible {
    func convertToToken(tokenSource: TokenSource) -> Token {
        return Token(
            string: "doesn't matter",
            ruleIdentifier: RuleIdentifier.Named(self),
            channel: .Default,
            source: tokenSource
        )
    }
}