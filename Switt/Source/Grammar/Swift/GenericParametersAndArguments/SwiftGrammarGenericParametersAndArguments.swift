class SwiftGrammarGenericParametersAndArguments: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.generic_parameter_clause,
            compound(
                required("<"),
                required(.generic_parameter_list),
                optional(.requirement_clause),
                required(">")
            )
        )
        
        register(.generic_parameter_list,
            compound(
                required(.generic_parameter),
                zeroOrMore(
                    required(","),
                    required(.generic_parameter)
                )
            )
        )
        
        register(.generic_parameter,
            any(
                required(.type_name),
                compound(
                    required(.type_name),
                    required(":"),
                    required(.type_identifier)
                ),
                compound(
                    required(.type_name),
                    required(":"),
                    required(.protocol_composition_type)
                )
            )
        )
        
        register(.requirement_clause,
            compound(
                required("where"),
                required(.requirement_list)
            )
        )
        
        register(.requirement_list,
            any(
                required(.requirement),
                compound(
                    required(.requirement),
                    required(","),
                    required(.requirement_list)
                )
            )
        )
        
        register(.requirement,
            any(
                .conformance_requirement,
                .same_type_requirement
            )
        )
        
        register(.conformance_requirement,
            any(
                compound(
                    required(.type_identifier),
                    required(":"),
                    required(.type_identifier)
                ),
                compound(
                    required(.type_identifier),
                    required(":"),
                    required(.protocol_composition_type)
                )
            )
        )
        
        register(.same_type_requirement,
            compound(
                required(.type_identifier),
                required(.same_type_equals),
                required(.type)
            )
        )
        
        register(.generic_argument_clause,
            compound(
                required("<"),
                required(.generic_argument_list),
                required(">")
            )
        )
        
        register(.generic_argument_list,
            compound(
                required(.generic_argument),
                zeroOrMore(
                    required(","),
                    required(.generic_argument)
                )
            )
        )
        
        register(.generic_argument,
            required(.type)
        )
    }
}