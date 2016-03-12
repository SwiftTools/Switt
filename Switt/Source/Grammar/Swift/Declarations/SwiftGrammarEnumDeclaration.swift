class SwiftGrammarEnumDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.enum_declaration,
            any(
                compound(
                    optional(.attributes),
                    optional(.access_level_modifier),
                    required(.union_style_enum)
                ),
                compound(
                    optional(.attributes),
                    optional(.access_level_modifier),
                    required(.raw_value_style_enum)
                )
            )
        )
        
        register(.union_style_enum,
            compound(
                optional("indirect"),
                required("enum"),
                required(.enum_name),
                optional(.generic_parameter_clause),
                optional(.type_inheritance_clause),
                required("{"),
                optional(.union_style_enum_members),
                required("}")
                
            )
        )
        
        register(.union_style_enum_members,
            compound(
                required(.union_style_enum_member),
                optional(.union_style_enum_members)
            )
        )
        
        register(.union_style_enum_member,
            any(
                .declaration,
                .union_style_enum_case_clause
            )
        )
        
        register(.union_style_enum_case_clause,
            compound(
                optional(.attributes),
                optional("indirect"),
                required("case"),
                required(.union_style_enum_case_list)
            )
        )
        
        register(.union_style_enum_case_list,
            any(
                required(.union_style_enum_case),
                compound(
                    required(.union_style_enum_case),
                    required(","),
                    required(.union_style_enum_case_list)
                )
            )
        )
        
        register(.union_style_enum_case,
            compound(
                required(.enum_case_name),
                optional(.tuple_type)
                
            )
        )
        
        register(.enum_name,
            required(.identifier)
        )
        
        register(.enum_case_name,
            required(.identifier)
        )
        
        register(.raw_value_style_enum,
            compound(
                required("enum"),
                required(.enum_name),
                optional(.generic_parameter_clause),
                required(.type_inheritance_clause),
                required("{"),
                required(.raw_value_style_enum_members),
                required("}")
                
            )
        )
        
        register(.raw_value_style_enum_members,
            compound(
                required(.raw_value_style_enum_member),
                optional(.raw_value_style_enum_members)
                
            )
        )
        
        register(.raw_value_style_enum_member,
            any(
                .declaration,
                .raw_value_style_enum_case_clause
            )
        )
        
        register(.raw_value_style_enum_case_clause,
            compound(
                optional(.attributes),
                required("case"),
                required(.raw_value_style_enum_case_list)
            )
        )
        
        register(.raw_value_style_enum_case_list,
            any(
                required(.raw_value_style_enum_case),
                compound(
                    required(.raw_value_style_enum_case),
                    required(","),
                    required(.raw_value_style_enum_case_list)
                )
            )
        )
        
        register(.raw_value_style_enum_case,
            compound(
                required(.enum_case_name),
                optional(.raw_value_assignment)
            )
        )
        
        register(.raw_value_assignment,
            compound(
                .assignment_operator,
                .raw_value_literal
            )
        )
        
        register(.raw_value_literal,
            any(
                .numeric_literal,
                .Static_string_literal,
                .boolean_literal
            )
        )
    }
}