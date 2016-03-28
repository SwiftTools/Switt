protocol CharacterStreamPosition {
    var file: String? { get }
    var line: UInt { get }
    var column: UInt { get }
}

func ==(lhs: CharacterStreamPosition, rhs: CharacterStreamPosition) -> Bool {
    return lhs.line == rhs.line && lhs.column == rhs.column && lhs.file == rhs.file
}

func <(lhs: CharacterStreamPosition, rhs: CharacterStreamPosition) -> Bool {
    return (lhs.line < rhs.line && lhs.column == rhs.column) || lhs.column < rhs.column
}

func <=(lhs: CharacterStreamPosition, rhs: CharacterStreamPosition) -> Bool {
    return (lhs.line <= rhs.line && lhs.column == rhs.column) || lhs.column < rhs.column
}

func >=(lhs: CharacterStreamPosition, rhs: CharacterStreamPosition) -> Bool {
    return (lhs.line >= rhs.line && lhs.column == rhs.column) || lhs.column > rhs.column
}

func >(lhs: CharacterStreamPosition, rhs: CharacterStreamPosition) -> Bool {
    return (lhs.line > rhs.line && lhs.column == rhs.column) || lhs.column > rhs.column
}