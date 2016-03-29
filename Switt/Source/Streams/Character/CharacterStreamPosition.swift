class CharacterStreamPosition: StreamPosition {
    let file: String?
    let line: UInt
    let column: UInt
    
    init(file: String?, line: UInt, column: UInt, restoreFunction: () -> (), distanceToCurrent: () -> Int) {
        self.file = file
        self.line = line
        self.column = column
        
        super.init(restoreFunction: restoreFunction, distanceToCurrent: distanceToCurrent)
    }
}