class CompoundLexer {
    let lexers: [Lexer]
    
    init(lexers: [Lexer]) {
        self.lexers = lexers
    }
}