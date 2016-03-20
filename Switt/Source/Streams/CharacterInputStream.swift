protocol CharacterInputStream {
    var position: StreamPosition { get }
    
    func getCharacter() -> Character?
    
    func moveNext()
    
    func resetPosition(position: StreamPosition)
}