class SwiftGrammarVariableDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.variable_declaration,
            any(
                compound(
                    .variable_declaration_head,
                    .pattern_initializer_list
                ),
                compound(
                    .variable_declaration_head,
                    .variable_name,
                    .type_annotation,
                    .code_block
                ),
                compound(
                    .variable_declaration_head,
                    .variable_name,
                    .type_annotation,
                    .getter_setter_block
                ),
                compound(
                    .variable_declaration_head,
                    .variable_name,
                    .type_annotation,
                    .getter_setter_keyword_block
                ),
                compound(
                    required(.variable_declaration_head),
                    required(.variable_name),
                    required(.type_annotation),
                    optional(.initializer),
                    required(.willSet_didSet_block)
                ),
                compound(
                    required(.variable_declaration_head),
                    required(.variable_name),
                    required(.type_annotation),
                    required(.type_annotation),
                    optional(.initializer),
                    required(.willSet_didSet_block)
                )
            )
        )
        
        register(.variable_declaration_head,
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("var")
                
            )
        )
        register(.variable_name,
            required(.identifier)
        )
        
        register(.getter_setter_block,
            any(
                compound(
                    required("{"),
                    required(.getter_clause),
                    optional(.setter_clause),
                    required("}")
                ),
                compound(
                    required("{"),
                    required(.setter_clause),
                    required(.getter_clause),
                    required("}")
                )
            )
        )
        
        register(.getter_clause,
            compound(
                optional(.attributes),
                required("get"),
                required(.code_block)
            )
        )
        register(.setter_clause,
            compound(
                optional(.attributes),
                required("set"),
                optional(.setter_name),
                required(.code_block)
            )
        )
        register(.setter_name,
            compound(
                required("("),
                required(.identifier),
                required(")")
            )
        )
        
        register(.getter_setter_keyword_block,
            any(
                compound(
                    required("{"),
                    required(.getter_keyword_clause),
                    optional(.setter_keyword_clause),
                    required("}")
                ),
                compound(
                    required("{"),
                    required(.setter_keyword_clause),
                    required(.getter_keyword_clause),
                    required("}")
                )
                
            )
        )
        
        register(.getter_keyword_clause,
            compound(
                optional(.attributes),
                required("get")
                
            )
        )
        register(.setter_keyword_clause,
            compound(
                optional(.attributes),
                required("set")
                
            )
        )
        
        register(.willSet_didSet_block,
            any(
                compound(
                    required("{"),
                    required(.willSet_clause),
                    optional(.didSet_clause),
                    required("}")
                ),
                compound(
                    required("{"),
                    required(.didSet_clause),
                    required(.willSet_clause),
                    required("}")
                )
                
            )
        )
        
        register(.willSet_clause,
            compound(
                optional(.attributes),
                required("willSet"),
                optional(.setter_name),
                required(.code_block)
            )
        )
        
        register(.didSet_clause,
            compound(
                optional(.attributes),
                required("didSet"),
                optional(.setter_name),
                required(.code_block)
            )
        )
    }
}