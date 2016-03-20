// Privacy of index guarantees that
// position could only be reset to a previous value
private class TokenInputOutputStreamPosition {
    var index: Int
    
    init(file: String? = nil, index: Int) {
        self.index = index
    }
}

class TokenInputOutputStream: TokenInputStream, TokenOutputStream {
    private var tokens: [Token] = []
    private var _position: TokenInputOutputStreamPosition
    
    init() {
        _position = TokenInputOutputStreamPosition(file: nil, index: 0)
    }
//    
//    var position: StreamPosition {
//        return _position
//    }
    
    func getToken() -> Token? {
        return tokens.at(_position.index)
    }
    
    func moveNext() {
//        if let token = getToken() {
//            switch char {
//            case "\n":
//                _position.line++
//                _position.column = 0
//            default:
//                _position.column++
//            }
//            _position.index = _position.index.advancedBy(1)
//        } else {
//            return
//        }
    }
//    
//    func resetPosition(position: StreamPosition) {
//        if let position = position as? TokenInputOutputStreamPosition {
//            _position = position
//        }
//    }
    
    func putToken(token: Token) {
        
    }
    
    func finish() {
        
    }
}