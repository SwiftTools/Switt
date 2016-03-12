class SwiftGrammarClassDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.class_declaration,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("class"),
                required(.class_name),
                optional(.generic_parameter_clause),
                optional(.type_inheritance_clause),
                required(.class_body)
            )
        )
        
        register(.class_name,
            required(.identifier)
        )
        register(.class_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}
