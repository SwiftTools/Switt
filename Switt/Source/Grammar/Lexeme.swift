indirect enum Lexeme {
    case Check(() -> ())
    case CharRanges(Bool, [CharRange])
    case Reference(LexemeType)
    case Compound([Lexeme])
    case Or([Lexeme])
    case Optional(Lexeme)
    case StringLexeme(String)
    case Multiple(UInt, Lexeme)
    case Eof
}