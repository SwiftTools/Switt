class SwiftGrammarInitializarDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.initializer_declaration,
            any(
                compound(
                    required(.initializer_head),
                    optional(.generic_parameter_clause),
                    required(.parameter_clause),
                    optional("throws"),
                    required(.initializer_body)
                ),
                compound(
                    required(.initializer_head),
                    optional(.generic_parameter_clause),
                    required(.parameter_clause),
                    required("rethrows"),
                    required(.initializer_body)
                )
            )
        )
        
        register(.initializer_head,
            any(
                compound(
                    optional(.attributes),
                    optional(.declaration_modifiers),
                    required("init")
                ),
                compound(
                    optional(.attributes),
                    optional(.declaration_modifiers),
                    required("init"),
                    required("?")
                ),
                compound(
                    optional(.attributes),
                    optional(.declaration_modifiers),
                    required("init"),
                    required("!")
                )
            )
        )
        
        register(.initializer_body,
            required(.code_block)
        )
    }
}