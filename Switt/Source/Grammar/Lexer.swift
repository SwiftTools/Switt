indirect enum Lexer {
    case Single(Lexer)
    case Compound(CompoundLexer)
    case Or(CompoundLexer)
    case Optional(Lexer)
    case StringType(String)
    case Repeating(Lexer)
}