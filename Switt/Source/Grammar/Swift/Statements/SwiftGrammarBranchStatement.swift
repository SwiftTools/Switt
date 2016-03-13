class SwiftGrammarBranchStatement: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.branch_statement,
            any(
                .if_statement,
                .guard_statement,
                .switch_statement
            )
        )
        
        // if
        
        register(.if_statement,
            compound(
                required("if"),
                required(.condition_clause),
                required(.code_block),
                optional(.else_clause)
            )
        )
        
        register(.else_clause,
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
        
        register(.guard_statement,
            compound(
                required("guard"),
                required(.condition_clause),
                required("else"),
                required(.code_block)
            )
        )
        
        // switch
        
        register(.switch_statement,
            compound(
                required("switch"),
                required(.expression),
                required("{"),
                optional(.switch_cases),
                required("}")
            )
        )
        
        register(.switch_cases,
            compound(
                required(.switch_case),
                optional(.switch_cases)
            )
        )
        
        register(.switch_cases,
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
        
        register(.case_label,
            compound(
                required("case"),
                required(.case_item_list),
                required(":")
            )
        )
        
        register(.case_item_list,
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
        
        register(.default_label,
            compound(
                required("default"),
                required(":")
            )
        )
        
        register(.where_clause,
            compound(
                required("default"),
                required(.where_expression)
            )
        )
        
        register(.where_expression,
            required(.expression)
        )
    }
}