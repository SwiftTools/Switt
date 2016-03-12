class SwiftGrammarFunctionDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.function_declaration,
            compound(
                required(.function_head),
                required(.function_name),
                optional(.generic_parameter_clause),
                required(.function_signature),
                optional(.function_body)
            )
        )
        
        register(.function_head,
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("func")
            )
        )
        
        register(.function_name,
            compound(
                required(.identifier),
                required(._operator)
            )
        )
        
        register(.function_signature,
            any(
                compound(
                    required(.parameter_clauses),
                    optional("throws"),
                    optional(.function_result)
                ),
                compound(
                    required(.parameter_clauses),
                    optional("rethrows"),
                    optional(.function_result)
                )
            )
        )
        
        register(.function_result,
            compound(
                required(.arrow_operator),
                optional(.attributes),
                required(.type)
            )
        )
        
        register(.function_body,
            required(.code_block)
        )
        
        register(.parameter_clauses,
            compound(
                required(.parameter_clause),
                optional(.parameter_clauses)
            )
        )
        
        register(.parameter_clause,
            any(
                compound(
                    required("("),
                    required(")")
                ),
                compound(
                    required("("),
                    required(.parameter_list),
                    required(")")
                )
            )
        )
        
        register(.parameter_list,
            compound(
                required(.parameter),
                zeroOrMore(
                    required(","),
                    required(.parameter)
                )
            )
        )
        
        let paramaterLexemes: [Lexeme] = [
            compound(
                required("let"),
                optional(.external_parameter_name),
                required(.local_parameter_name),
                optional(.type_annotation),
                optional(.default_argument_clause)
            ),
            compound(
                required("var"),
                optional(.external_parameter_name),
                required(.local_parameter_name),
                optional(.type_annotation),
                optional(.default_argument_clause)
            ),
            compound(
                required("inout"),
                optional(.external_parameter_name),
                required(.local_parameter_name),
                required(.type_annotation)
            ),
            compound(
                optional(.external_parameter_name),
                required(.local_parameter_name),
                required(.type_annotation),
                required(.range_operator)
            )
        ]
        register(.parameter,
            any(
                paramaterLexemes
            )
        )
        
        register(.external_parameter_name,
            any(
                required(.identifier),
                required("_")
            )
        )
        
        register(.local_parameter_name,
            any(
                required(.identifier),
                required("_")
            )
        )
        
        register(.default_argument_clause,
            compound(
                .assignment_operator,
                .expression
            )
        )
    }
}