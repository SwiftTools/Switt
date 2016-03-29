class SwiftGrammarGenericParametersAndArguments: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.generic_parameter_clause,
            compound(
                required("<"),
                required(.generic_parameter_list),
                optional(.requirement_clause),
                required(">")
            )
        )
        
        parserRule(.generic_parameter_list,
            compound(
                required(.generic_parameter),
                zeroOrMore(
                    required(","),
                    required(.generic_parameter)
                )
            )
        )
        
        parserRule(.generic_parameter,
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
        
        parserRule(.requirement_clause,
            compound(
                required("where"),
                required(.requirement_list)
            )
        )
        
        parserRule(.requirement_list,
            any(
                required(.requirement),
                compound(
                    required(.requirement),
                    required(","),
                    required(.requirement_list)
                )
            )
        )
        
        parserRule(.requirement,
            any(
                .conformance_requirement,
                .same_type_requirement
            )
        )
        
        parserRule(.conformance_requirement,
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
        
        parserRule(.same_type_requirement,
            compound(
                required(.type_identifier),
                required(.same_type_equals),
                required(.type)
            )
        )
        
        parserRule(.generic_argument_clause,
            compound(
                required("<"),
                required(.generic_argument_list),
                required(">")
            )
        )
        
        parserRule(.generic_argument_list,
            compound(
                required(.generic_argument),
                zeroOrMore(
                    required(","),
                    required(.generic_argument)
                )
            )
        )
        
        parserRule(.generic_argument,
            required(.type)
        )
    }
}