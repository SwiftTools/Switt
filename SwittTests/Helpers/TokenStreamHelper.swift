@testable import Switt

class TokenStreamHelper {
    static func tokenStream(tokens: [TokenConvertible]) -> TokenInputStreamTestable {
        let stream = TokenInputOutputStream()
        
        tokens
            .map { convertToToken(stream: stream, tokenConvertible: $0) }
            .forEach { stream.putToken($0) }
        
        return TokenInputStreamTestable(stream: stream)
    }
    
    static func convertToToken(stream stream: TokenInputOutputStream, tokenConvertible: TokenConvertible) -> Token {
        var token = tokenConvertible.convertToToken(
            TokenSource(
                stream: stream,
                position: stream.positionForIndex(stream.tokens.count)
            )
        )
        
        if token.ruleIdentifier == RuleIdentifier.Named(.WS)
            || token.ruleIdentifier == RuleIdentifier.Named(.WS)
            || token.ruleIdentifier == RuleIdentifier.Named(.WS)
        {
            token.channel = .Hidden
        }
        
        return token
    }
}