class SwiftGrammarDeinitializerDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.deinitializer_declaration,
            compound(
                optional(.attributes),
                required("deinit"),
                required(.code_block)
            )
        )
    }
}