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

extension CharRange {
    init(first: UnicodeScalar, last: UnicodeScalar) {
        self.init(first: first.value, last: last.value)
    }
    
//    init(first: Character, last: Character) {
//        self.init(first: first.toUInt32(), last: last.toUInt32())
//    }
//    
    init(char: UnicodeScalar) {
        self.init(first: char.value, last: char.value)
    }
//    
//    init(char: Character) {
//        self.init(first: char.toUInt32(), last: char.toUInt32())
//    }
}