// Privacy of index guarantees that
// position could only be reset to a previous value
private struct InputStringStreamPosition: StreamPosition {
    var index: String.Index
    var file: String?
    var line: UInt
    var column: UInt
}

class CharacterInputStringStream: CharacterInputStream {
    private var string: String
    private var _position: InputStringStreamPosition
    
    var position: StreamPosition {
        return _position
    }
    
    init(string: String) {
        self.string = string
        
        _position = InputStringStreamPosition(
            index: string.startIndex,
            file: nil,
            line: 0,
            column: 0
        )
    }
    
    func resetPosition(position: StreamPosition) {
        if let position = position as? InputStringStreamPosition {
            _position = position
        }
    }
    
    func getCharacter() -> Character? {
        if _position.index >= string.endIndex {
            return nil
        } else {
            return string[_position.index]
        }
    }
    
    func moveNext() {
        if let char = getCharacter() {
            switch char {
            case "\n":
                _position.line++
                _position.column = 0
            default:
                _position.column++
            }
            _position.index = _position.index.advancedBy(1)
        } else {
            return
        }
    }
}