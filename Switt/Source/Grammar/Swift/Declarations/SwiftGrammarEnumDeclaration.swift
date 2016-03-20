class SwiftGrammarEnumDeclaration: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.enum_declaration,
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
        
        parserRule(.union_style_enum,
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
        
        parserRule(.union_style_enum_members,
            compound(
                required(.union_style_enum_member),
                optional(.union_style_enum_members)
            )
        )
        
        parserRule(.union_style_enum_member,
            any(
                .declaration,
                .union_style_enum_case_clause
            )
        )
        
        parserRule(.union_style_enum_case_clause,
            compound(
                optional(.attributes),
                optional("indirect"),
                required("case"),
                required(.union_style_enum_case_list)
            )
        )
        
        parserRule(.union_style_enum_case_list,
            any(
                required(.union_style_enum_case),
                compound(
                    required(.union_style_enum_case),
                    required(","),
                    required(.union_style_enum_case_list)
                )
            )
        )
        
        parserRule(.union_style_enum_case,
            compound(
                required(.enum_case_name),
                optional(.tuple_type)
                
            )
        )
        
        parserRule(.enum_name,
            required(.identifier)
        )
        
        parserRule(.enum_case_name,
            required(.identifier)
        )
        
        parserRule(.raw_value_style_enum,
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
        
        parserRule(.raw_value_style_enum_members,
            compound(
                required(.raw_value_style_enum_member),
                optional(.raw_value_style_enum_members)
                
            )
        )
        
        parserRule(.raw_value_style_enum_member,
            any(
                .declaration,
                .raw_value_style_enum_case_clause
            )
        )
        
        parserRule(.raw_value_style_enum_case_clause,
            compound(
                optional(.attributes),
                required("case"),
                required(.raw_value_style_enum_case_list)
            )
        )
        
        parserRule(.raw_value_style_enum_case_list,
            any(
                required(.raw_value_style_enum_case),
                compound(
                    required(.raw_value_style_enum_case),
                    required(","),
                    required(.raw_value_style_enum_case_list)
                )
            )
        )
        
        parserRule(.raw_value_style_enum_case,
            compound(
                required(.enum_case_name),
                optional(.raw_value_assignment)
            )
        )
        
        parserRule(.raw_value_assignment,
            compound(
                .assignment_operator,
                .raw_value_literal
            )
        )
        
        parserRule(.raw_value_literal,
            any(
                .numeric_literal,
                .Static_string_literal,
                .boolean_literal
            )
        )
    }
}