class SwiftGrammarStatements: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        // statements
        
        let statementRules: [ProductionRule] = [
            compound(
                required(.expression),
                optional(";")
            ),
            compound(
                required(.declaration),
                optional(";")
            ),
            compound(
                required(.loop_statement),
                optional(";")
            ),
            compound(
                required(.branch_statement),
                optional(";")
            ),
            compound(
                required(.labeled_statement),
                optional(";")
            ),
            compound(
                required(.control_transfer_statement),
                optional(";")
            ),
            compound(
                required(.defer_statement),
                optional(";")
            ),
            compound(
                required(.do_statement),
                optional(";")
            ),
            required(.compiler_control_statement)
        ]
        parserRule(.statement,
            any(
                statementRules
            )
        )
        
        parserRule(.statements,
            oneOrMore(.statement)
        )
        
        // labeled
        
        parserRule(.labeled_statement,
            any(
                compound(
                    required(.statement_label),
                    required(.loop_statement)
                ),
                compound(
                    required(.statement_label),
                    required(.if_statement)
                ),
                compound(
                    required(.statement_label),
                    required(.switch_statement)
                )
            )
        )
        
        
        parserRule(.statement_label,
            compound(
                required(.label_name),
                required(":")
            )
        )
        
        parserRule(.label_name,
            compound(
                required(.identifier)
            )
        )
        
        // control transfer
        
        parserRule(.control_transfer_statement,
            any(
                .break_statement,
                .continue_statement,
                .fallthrough_statement,
                .return_statement,
                .throw_statement
            )
        )
        
        // break
        
        parserRule(.break_statement,
            compound(
                required("break"),
                optional(.label_name)
            )
        )
        
        // continue
        
        parserRule(.continue_statement,
            compound(
                required("continue"),
                optional(.label_name)
            )
        )
        
        // fallthrough
        
        parserRule(.fallthrough_statement,
            required("fallthrough")
        )
        
        // return
        
        parserRule(.return_statement,
            compound(
                required("return"),
                optional(.expression)
            )
        )
        
        // throw
        
        parserRule(.throw_statement,
            compound(
                required("throw"),
                required(.expression)
            )
        )
        
        // defer
        
        parserRule(.defer_statement,
            compound(
                required("defer"),
                required(.code_block)
            )
        )
        
        // do
        
        parserRule(.do_statement,
            compound(
                required("do"),
                required(.code_block),
                optional(.catch_clauses)
            )
        )
        
        // catch
        
        parserRule(.catch_clauses,
            compound(
                required(.catch_clause),
                optional(.catch_clauses)
            )
        )
        
        parserRule(.catch_clause,
            compound(
                required("catch"),
                optional(.pattern),
                optional(.where_clause),
                required(.code_block)
            )
        )
        
        append(SwiftGrammarLoopStatement())
        append(SwiftGrammarBranchStatement())
        append(SwiftGrammarAvailabilityStatements())
        append(SwiftGrammarCompilerControlStatements())
    }
}