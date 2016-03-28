@testable import Switt

extension TokenInputStream {
    var tokens: [Token] {
        var tokens: [Token] = []
        let position = self.position
        while let token = getToken() {
            tokens.append(token)
            moveNext()
        }
        position.restore()
        return tokens
    }
}
