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

struct CharRange: CustomDebugStringConvertible, Equatable {
    var first: UInt32
    var last: UInt32
    
    func contains(character: Character) -> Bool {
        let intRepresentation = character.toUInt32()
        return intRepresentation >= first && intRepresentation <= last
    }
    
    var debugDescription: String {
        if first == last {
            return "0x" + String(first, radix: 0x10, uppercase: false)
        } else {
            return "[0x" + String(first, radix: 0x10, uppercase: false) + "-0x" + String(last, radix: 0x10, uppercase: false) + "]"
        }
    }
}

func ==(left: CharRange, right: CharRange) -> Bool {
    return left.first == right.first && left.last == right.last
}