protocol LexemeBuilder: class {
    var lexemes: [LexemeType: Lexeme] { get set }
    var fragments: [LexemeType: Lexeme] { get set }
    
    func registerLexemes()
}

class LexemesMath {
    static func lexeme(string: String) -> Lexeme {
        return Lexeme.StringLexeme(string)
    }
    
    static func lexeme(lexeme: Lexeme) -> Lexeme {
        return lexeme
    }
    
    static func lexeme(lexemeType: LexemeType) -> Lexeme {
        return Lexeme.Reference(lexemeType)
    }
    
    static func optional(string: String) -> Lexeme {
        return Lexeme.Optional(lexeme(string))
    }
    
    static func optional(lexeme: Lexeme) -> Lexeme {
        return Lexeme.Optional(lexeme)
    }
    
    static func optional(lexemeType: LexemeType) -> Lexeme {
        return Lexeme.Optional(lexeme(lexemeType))
    }
    
    static func compound(lexemes: [Lexeme]) -> Lexeme {
        if lexemes.count > 1 {
            return Lexeme.Compound(lexemes)
        } else {
            return lexemes.first!
        }
    }
    
    static func any(lexemes: [Lexeme]) -> Lexeme {
        if lexemes.count > 1 {
            return Lexeme.Or(lexemes)
        } else {
            return lexemes.first!
        }
    }
    
    static func zeroOrMore(lexemes: [Lexeme]) -> Lexeme {
        if lexemes.count > 1 {
            return Lexeme.Multiple(0, compound(lexemes))
        } else {
            return Lexeme.Multiple(0, lexemes.first!)
        }
    }
}

struct CharRange {
    var first: UInt32
    var last: UInt32
}

extension LexemeBuilder {
    // building
    
    func clearLexemes() {
        lexemes = [:]
    }
    
    func append(lexemeBuilder: LexemeBuilder) {
        lexemeBuilder.clearLexemes()
        lexemeBuilder.registerLexemes()
        for (type, lexeme) in lexemeBuilder.lexemes {
            lexemes[type] = lexeme
        }
    }
    
    func register(type: LexemeType, _ lexeme: Lexeme) {
        lexemes[type] = lexeme
    }
    
    func registerFragment(type: LexemeType, _ lexeme: Lexeme) {
        lexemes[type] = lexeme
    }
    
    // compound
    
    func compound(lexemes: [Lexeme]) -> Lexeme {
        return LexemesMath.compound(lexemes)
    }
    
    func compound(lexemes: Lexeme...) -> Lexeme {
        let lexemes: [Lexeme] = lexemes
        return compound(lexemes)
    }
    
    func compound(lexemeTypes: LexemeType...) -> Lexeme {
        return compound(lexemeTypes.map { required($0) })
    }
    
    func compound(strings: String...) -> Lexeme {
        return compound(strings.map { required($0) })
    }
    
    // any
    
    func any(lexemes: [Lexeme]) -> Lexeme {
        return LexemesMath.any(lexemes)
    }
    
    func any(strings: String...) -> Lexeme {
        return any(strings.map { required($0) })
    }
    
    func any(lexemeTypes: LexemeType...) -> Lexeme {
        return any(lexemeTypes.map { required($0) })
    }
    
    func any(lexemes: Lexeme...) -> Lexeme {
        let lexemes: [Lexeme] = lexemes
        return any(lexemes)
    }
    
    // zeroOrMore
    
    func zeroOrMore(lexemes: [Lexeme]) -> Lexeme {
        return LexemesMath.zeroOrMore(lexemes)
    }
    
    func zeroOrMore(lexemes: Lexeme...) -> Lexeme {
        let lexemes: [Lexeme] = lexemes
        return zeroOrMore(lexemes)
    }
    
    func zeroOrMore(lexemeTypes: LexemeType...) -> Lexeme {
        return zeroOrMore(lexemeTypes.map { required($0) })
    }
    
    // oneOrMore
    
    func oneOrMore(lexemes: Lexeme...) -> Lexeme {
        if lexemes.count > 1 {
            return Lexeme.Multiple(1, Lexeme.Compound(lexemes))
        } else {
            return Lexeme.Multiple(1, lexemes.first!)
        }
    }
    
    func oneOrMore(lexemeTypes: LexemeType...) -> Lexeme {
        if lexemeTypes.count > 1 {
            return Lexeme.Multiple(1, Lexeme.Compound(lexemeTypes.map { Lexeme.Reference($0) }))
        } else {
            return Lexeme.Multiple(1, required(lexemeTypes.first!))
        }
        
    }
    
    // required
    
    func required(lexemeType: LexemeType) -> Lexeme {
        return LexemesMath.lexeme(lexemeType)
    }
    
    func required(string: String) -> Lexeme {
        return LexemesMath.lexeme(string)
    }
    
    // optional
    
    func optional(lexemeType: LexemeType) -> Lexeme {
        return Lexeme.Optional(LexemesMath.lexeme(lexemeType))
    }
    
    func optional(string: String) -> Lexeme {
        return Lexeme.Optional(LexemesMath.lexeme(string))
    }
    
    // chars
    
    func char(value: UInt32) -> Lexeme {
        return .CharRanges(true, [CharRange(first: value, last: value)])
    }
    
    func char(first: UInt32, _ last: UInt32) -> Lexeme {
        return .CharRanges(true, [CharRange(first: first, last: last)])
    }
    
    func char(first: UnicodeScalar, _ last: UnicodeScalar) -> Lexeme {
        return .CharRanges(true, [CharRange(first: first.value, last: last.value)])
    }
    
    func char(first: UnicodeScalar) -> Lexeme {
        return .CharRanges(true, [CharRange(first: first.value, last: first.value)])
    }
    
    func char(chars: [UnicodeScalar]) -> Lexeme {
        var ranges = [CharRange]()
        for char in chars {
            ranges.append(CharRange(first: char.value, last: char.value))
        }
        return .CharRanges(true, ranges)
    }
    
    func anyChar() -> Lexeme {
        return .CharRanges(true, [CharRange(first: UInt32.min, last: UInt32.max)])
    }
    
    // *?
    // TODO: implement
    func lazy(lexeme: Lexeme) -> Lexeme {
        return lexeme
    }
    
    func notChar(chars: [UnicodeScalar]) -> Lexeme {
        var ranges = [CharRange]()
        for char in chars {
            ranges.append(CharRange(first: char.value, last: char.value))
        }
        return .CharRanges(false, ranges)
    }
    
    // check
    
    func check(closure: () -> ()) -> Lexeme {
        return .Check(closure)
    }
    
    // times
    
    func times(times: UInt, _ lexemeType: LexemeType) -> Lexeme {
        var lexemes: [Lexeme] = []
        for _ in 0..<times {
            lexemes.append(LexemesMath.lexeme(lexemeType))
        }
        return compound(lexemes)
    }
    
    // misc
    
    func eof() -> Lexeme {
        return Lexeme.Eof
    }
}

infix operator ~ { associativity left precedence 140 }
infix operator | { associativity left precedence 130 }
prefix operator ?? {}
prefix operator ~ {}

prefix func ??(lexemeType: LexemeType) -> Lexeme {
    return LexemesMath.optional(lexemeType)
}

prefix func ??(string: String) -> Lexeme {
    return LexemesMath.optional(string)
}

prefix func ~(lexemeType: LexemeType) -> Lexeme {
    return LexemesMath.lexeme(lexemeType)
}

prefix func ~(string: String) -> Lexeme {
    return LexemesMath.lexeme(string)
}

func ~(left: String, right: String) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: String, right: LexemeType) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: String, right: Lexeme) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: LexemeType, right: String) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: LexemeType, right: LexemeType) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: LexemeType, right: Lexeme) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: Lexeme, right: String) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: Lexeme, right: LexemeType) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func ~(left: Lexeme, right: Lexeme) -> Lexeme {
    return LexemesMath.compound(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}


////


func |(left: String, right: String) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: String, right: LexemeType) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: String, right: Lexeme) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: LexemeType, right: String) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: LexemeType, right: LexemeType) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: LexemeType, right: Lexeme) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: Lexeme, right: String) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: Lexeme, right: LexemeType) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}

func |(left: Lexeme, right: Lexeme) -> Lexeme {
    return LexemesMath.any(
        [
            LexemesMath.lexeme(left),
            LexemesMath.lexeme(right)
        ]
    )
}