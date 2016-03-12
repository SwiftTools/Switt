class SwiftGrammarStructDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.struct_declaration,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("struct"),
                required(.struct_name),
                optional(.generic_parameter_clause),
                optional(.type_inheritance_clause),
                required(.struct_body)
            )
        )
        
        register(.struct_name,
            required(.identifier)
        )
        
        register(.struct_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}