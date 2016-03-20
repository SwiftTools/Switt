protocol StreamPosition {
    var file: String? { get }
    var line: UInt { get }
    var column: UInt { get }
}

func ==(lhs: StreamPosition, rhs: StreamPosition) -> Bool {
    return lhs.line == rhs.line && lhs.column == rhs.column && lhs.file == rhs.file
}

func <(lhs: StreamPosition, rhs: StreamPosition) -> Bool {
    return (lhs.line < rhs.line && lhs.column == rhs.column) || lhs.column < rhs.column
}

func <=(lhs: StreamPosition, rhs: StreamPosition) -> Bool {
    return (lhs.line <= rhs.line && lhs.column == rhs.column) || lhs.column < rhs.column
}

func >=(lhs: StreamPosition, rhs: StreamPosition) -> Bool {
    return (lhs.line >= rhs.line && lhs.column == rhs.column) || lhs.column > rhs.column
}

func >(lhs: StreamPosition, rhs: StreamPosition) -> Bool {
    return (lhs.line > rhs.line && lhs.column == rhs.column) || lhs.column > rhs.column
}