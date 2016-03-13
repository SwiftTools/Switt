extension Character {
    func toUnicodeScalar() -> UnicodeScalar {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex]
    }
    func toUInt32() -> UInt32 {
        return toUnicodeScalar().value
    }
}

struct CharRange {
    var first: UInt32
    var last: UInt32
    
    func contains(character: Character) -> Bool {
        let intRepresentation = character.toUInt32()
        return intRepresentation >= first && intRepresentation <= last
    }
}