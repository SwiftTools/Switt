@testable import Switt

class TokenStreamHelper {
    static func tokenStream(tokens: [TokenConvertible]) -> TokenInputStreamTestable {
        let stream = TokenInputOutputStream()
        
        tokens
            .map { $0.convertToToken() }
            .forEach { stream.putToken($0) }
        
        return TokenInputStreamTestable(stream: stream)
    }
}