class SwiftGrammarLoopStatement: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        // loop
        
        register(.loop_statement,
            any(
                .for_statement,
                .for_in_statement,
                .while_statement,
                .repeat_while_statement
            )
        )
        
        // for
        
        let forStatementRules: [ProductionRule] = [
            compound(
                required("for"),
                required(.for_init),
                required(";"),
                optional(.expression),
                required(";"),
                optional(.expression),
                required(.code_block)
            ),
            compound(
                required("for"),
                required("("),
                required(.for_init),
                required(";"),
                optional(.expression),
                required(";"),
                optional(.expression),
                required(")"),
                required(.code_block)
            )
        ]
        register(.for_statement,
            any(
                forStatementRules
            )
        )
        
        register(.for_init,
            any(
                .variable_declaration,
                .expression_list
            )
        )
        
        // for in
        
        register(.for_in_statement,
            compound(
                required("for"),
                optional("case"),
                required(.pattern),
                required("in"),
                required(.expression),
                optional(.where_clause),
                required(.code_block)
            )
        )
        
        // while
        
        register(.while_statement,
            compound(
                required("while"),
                required(.condition_clause),
                required(.code_block)
            )
        )
        
        register(.condition_clause,
            any(
                required(.expression),
                compound(
                    required(.expression),
                    required(","),
                    required(.condition_list)
                ),
                required(.condition_list),
                compound(
                    required(.availability_condition),
                    required(","),
                    required(.expression)
                )
            )
        )
        
        register(.condition_list,
            compound(
                required(.condition),
                zeroOrMore(
                    required(","),
                    required(.condition)
                )
            )
        )
        
        register(.condition,
            any(
                .availability_condition,
                .case_condition,
                .optional_binding_condition
            )
        )
        
        register(.case_condition,
            compound(
                required("case"),
                required(.pattern),
                required(.initializer),
                optional(.where_clause)
            )
        )
        
        register(.optional_binding_condition,
            compound(
                required(.optional_binding_head),
                optional(.optional_binding_continuation_list),
                optional(.where_clause)
            )
        )
        
        register(.optional_binding_head,
            any(
                compound(
                    required("let"),
                    required(.pattern),
                    required(.initializer)
                ),
                compound(
                    required("var"),
                    required(.pattern),
                    required(.initializer)
                )
            )
        )
        
        register(.optional_binding_continuation_list,
            compound(
                required(","),
                required(.optional_binding_continuation),
                zeroOrMore(
                    required(","),
                    required(.optional_binding_continuation)
                )
            )
        )
        
        register(.optional_binding_continuation,
            any(
                compound(
                    required(.pattern),
                    required(.initializer)
                ),
                required(.optional_binding_head)
            )
        )
        
        // repeat while
        
        register(.repeat_while_statement,
            compound(
                required("repeat"),
                required(.code_block),
                required("while"),
                required(.expression)
            )
        )
    }
}