protocol CharacterInputStream {
    var position: CharacterStreamPosition { get }
    
    func getCharacter() -> Character?
    
    func moveNext()
    
    func resetPosition(position: CharacterStreamPosition)
}