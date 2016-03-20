class SwiftGrammarBranchStatement: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.branch_statement,
            any(
                .if_statement,
                .guard_statement,
                .switch_statement
            )
        )
        
        // if
        
        parserRule(.if_statement,
            compound(
                required("if"),
                required(.condition_clause),
                required(.code_block),
                optional(.else_clause)
            )
        )
        
        parserRule(.else_clause,
            any(
                compound(
                    required("else"),
                    required(.code_block)
                ),
                compound(
                    required("else"),
                    required(.if_statement)
                )
            )
        )
        
        // guard
        
        parserRule(.guard_statement,
            compound(
                required("guard"),
                required(.condition_clause),
                required("else"),
                required(.code_block)
            )
        )
        
        // switch
        
        parserRule(.switch_statement,
            compound(
                required("switch"),
                required(.expression),
                required("{"),
                optional(.switch_cases),
                required("}")
            )
        )
        
        parserRule(.switch_cases,
            compound(
                required(.switch_case),
                optional(.switch_cases)
            )
        )
        
        parserRule(.switch_cases,
            any(
                compound(
                    required(.case_label),
                    required(.statements)
                ),
                compound(
                    required(.default_label),
                    required(.statements)
                )
            )
        )
        
        parserRule(.case_label,
            compound(
                required("case"),
                required(.case_item_list),
                required(":")
            )
        )
        
        parserRule(.case_item_list,
            any(
                compound(
                    required(.pattern),
                    optional(.where_clause)
                ),
                compound(
                    required(.pattern),
                    optional(.where_clause),
                    required(","),
                    required(.case_item_list)
                )
            )
        )
        
        parserRule(.default_label,
            compound(
                required("default"),
                required(":")
            )
        )
        
        parserRule(.where_clause,
            compound(
                required("default"),
                required(.where_expression)
            )
        )
        
        parserRule(.where_expression,
            required(.expression)
        )
    }
}