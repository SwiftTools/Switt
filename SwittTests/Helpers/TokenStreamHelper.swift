@testable import Switt

class TokenStreamHelper {
    static func tokenStream(tokens: [TokenConvertible], currentIndex: Int = 0) -> TokenInputOutputStream {
        let stream = TokenInputOutputStream()
        
        tokens.forEach { stream.putToken(convertToToken(stream: stream, tokenConvertible: $0)) }
        
        for _ in 0..<currentIndex {
            stream.moveNext()
        }
        
        return stream
    }
    
    static func convertToToken(stream stream: TokenInputOutputStream, tokenConvertible: TokenConvertible) -> Token {
        var token = tokenConvertible.convertToToken(
            TokenSource(
                stream: stream,
                position: stream.positionForIndex(stream.tokens.count)
            )
        )
        
        if token.string == " " {
            token.ruleIdentifier = RuleIdentifier.Named(.WS)
        }
        
        if token.ruleIdentifier == RuleIdentifier.Named(.WS)
            || token.ruleIdentifier == RuleIdentifier.Named(.Line_comment)
            || token.ruleIdentifier == RuleIdentifier.Named(.Block_comment)
        {
            token.channel = .Hidden
        }
        
        return token
    }
}