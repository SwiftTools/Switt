class SwiftGrammarPatterns: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        let patternRules: [ProductionRule] = [
            compound(
                required(.wildcard_pattern),
                optional(.type_annotation)
            ),
            compound(
                required(.identifier_pattern),
                optional(.type_annotation)
            ),
            required(.value_binding_pattern),
            compound(
                required(.tuple_pattern),
                optional(.type_annotation)
            ),
            required(.enum_case_pattern),
            required(.optional_pattern),
            compound(
                required("is"),
                optional(.type)
            ),
            compound(
                optional(.pattern),
                required("as"),
                optional(.type)
            ),
            required(.expression_pattern)
        ]
        parserRule(.pattern,
            any(
                patternRules
            )
        )
        
        parserRule(.wildcard_pattern,
            required("_")
        )
        
        parserRule(.identifier_pattern,
            required(.identifier)
        )
        
        parserRule(.value_binding_pattern,
            any(
                compound(
                    required("var"),
                    required(.pattern)
                ),
                compound(
                    required("let"),
                    required(.pattern)
                )
            )
        )
        
        parserRule(.tuple_pattern,
            compound(
                required("("),
                optional(.tuple_pattern_element_list),
                required(")")
            )
        )
        
        parserRule(.tuple_pattern_element_list,
            compound(
                required(.tuple_pattern_element),
                zeroOrMore(
                    required(","),
                    required(.tuple_pattern_element)
                )
                
            )
        )
        
        parserRule(.tuple_pattern_element,
            required(.pattern)
        )
        
        parserRule(.enum_case_pattern,
            compound(
                optional(.type_identifier),
                required("."),
                required(.enum_case_name),
                optional(.tuple_pattern)
                
            )
        )
        
        parserRule(.optional_pattern,
            compound(
                required(.identifier_pattern),
                required("?")
            )
        )
        
        /** Doc says "Expression patterns appear only in switch statement case labels." */
        parserRule(.expression_pattern,
            required(.expression)
        )
    }
}