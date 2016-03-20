class SwiftGrammarCompilerControlStatements: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.compiler_control_statement,
            any(
                required(.build_configuration_statement),
                required(.line_control_statement)
            )
        )
        
        // #if
        
        parserRule(.build_configuration_statement,
            compound(
                required("#if"),
                required(.build_configuration),
                optional(.statements),
                optional(.build_configuration_elseif_clauses),
                optional(.build_configuration_else_clause),
                required("#endif")
                
            )
        )
        
        parserRule(.build_configuration_elseif_clauses,
            compound(
                required(.build_configuration_elseif_clause),
                optional(.build_configuration_elseif_clauses)
                
            )
        )
        parserRule(.build_configuration_elseif_clause,
            compound(
                required("#elseif"),
                required(.build_configuration),
                optional(.statements)
                
            )
        )
        parserRule(.build_configuration_else_clause,
            compound(
                required("#else"),
                optional(.statements)
                
            )
        )
        
        parserRule(.build_configuration,
            any(
                required(.platform_testing_function),
                required(.identifier),
                required(.boolean_literal),
                compound(
                    required("("),
                    required(.build_configuration),
                    required(")")
                ),
                compound(
                    required("!"),
                    required(.build_configuration)
                ),
                compound(
                    required(.build_configuration),
                    required(.build_AND),
                    required(.build_configuration)
                ),
                compound(
                    required(.build_configuration),
                    required(.build_OR),
                    required(.build_configuration)
                )
            )
        )
        
        
        parserRule(.platform_testing_function,
            any(
                compound(
                    required("os"),
                    required("("),
                    required(.operating_system),
                    required(")")
                ),
                compound(
                    required("arch"),
                    required("("),
                    required(.architecture),
                    required(")")
                )
            )
        )
        
        parserRule(.operating_system,
            any(
                "OSX", "iOS", "watchOS", "tvOS"
            )
        )
        parserRule(.architecture,
            any(
                "i386", "x86_64", "arm", "arm64"
            )
        )
        
        // line
        
        parserRule(.line_control_statement,
            any(
                required("#line"),
                compound(
                    required("#line"),
                    required(.line_number),
                    required(.file_name)
                )
            )
        )
        
        parserRule(.line_number,
            required(.integer_literal)
        )
        
        // file
        
        parserRule(.file_name,
            required(.Static_string_literal)
        )
    }
}