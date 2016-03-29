private struct Position {
    var index: String.Index
    var file: String?
    var line: UInt
    var column: UInt
}

class CharacterInputStringStream: CharacterInputStream {
    private var string: String
    private var currentPosition: Position
    
    var position: CharacterStreamPosition {
        return CharacterStreamPosition(
            file: currentPosition.file,
            line: currentPosition.line,
            column: currentPosition.column,
            restoreFunction: { [weak self, savedPosition = currentPosition] in
                self?.currentPosition = savedPosition
            },
            distanceToCurrent: { [weak self, startIndex = string.startIndex, savedPosition = currentPosition] in
                return savedPosition.index.distanceTo(self?.currentPosition.index ?? startIndex)
            }
        )
    }
    
    init(string: String) {
        self.string = string
        
        currentPosition = Position(
            index: string.startIndex,
            file: nil,
            line: 0,
            column: 0
        )
    }
    
    func getCharacter() -> Character? {
        return string.characters.at(currentPosition.index)
    }
    
    func moveNext() {
        if let char = getCharacter() {
            switch char {
            case "\n":
                currentPosition.line += 1
                currentPosition.column = 0
            default:
                currentPosition.column += 1
            }
            currentPosition.index = currentPosition.index.advancedBy(1)
        } else {
            return
        }
    }
}