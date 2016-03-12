class SwiftGrammarExtensionDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.extension_declaration,
            compound(
                optional(.access_level_modifier),
                required("extension"),
                required(.type_identifier),
                optional(.type_inheritance_clause),
                required(.extension_body)
            )
        )
        register(.extension_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}