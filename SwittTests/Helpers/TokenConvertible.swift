@testable import Switt

protocol TokenConvertible {
    func convertToToken() -> Token
}

extension String: TokenConvertible {
    func convertToToken() -> Token {
        return Token(
            string: self,
            ruleIdentifier: RuleIdentifier.Unnamed(self),
            channel: .Default
        )
    }
}

extension Token: TokenConvertible {
    func convertToToken() -> Token {
        return self
    }
}

extension RuleName: TokenConvertible {
    func convertToToken() -> Token {
        return Token(
            string: "doesn't matter",
            ruleIdentifier: RuleIdentifier.Named(self),
            channel: .Default
        )
    }
}