class SwiftGrammarStatements: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        append(SwiftGrammarLoopStatement())
        append(SwiftGrammarBranchStatement())
        append(SwiftGrammarAvailabilityStatements())
        append(SwiftGrammarCompilerControlStatements())
        
        // statements
        
        let statementLexemes: [Lexeme] = [
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
        register(.statement,
            any(
                statementLexemes
            )
        )
        
        register(.statements,
            oneOrMore(.statement)
        )
        
        // labeled
        
        register(.labeled_statement,
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
        
        
        register(.statement_label,
            compound(
                required(.label_name),
                required(":")
            )
        )
        
        register(.label_name,
            compound(
                required(.identifier)
            )
        )
        
        // control transfer
        
        register(.control_transfer_statement,
            any(
                .break_statement,
                .continue_statement,
                .fallthrough_statement,
                .return_statement,
                .throw_statement
            )
        )
        
        // break
        
        register(.break_statement,
            compound(
                required("break"),
                optional(.label_name)
            )
        )
        
        // continue
        
        register(.continue_statement,
            compound(
                required("continue"),
                optional(.label_name)
            )
        )
        
        // fallthrough
        
        register(.fallthrough_statement,
            required("fallthrough")
        )
        
        // return
        
        register(.return_statement,
            compound(
                required("return"),
                optional(.expression)
            )
        )
        
        // throw
        
        register(.throw_statement,
            compound(
                required("throw"),
                required(.expression)
            )
        )
        
        // defer
        
        register(.defer_statement,
            compound(
                required("defer"),
                required(.code_block)
            )
        )
        
        // do
        
        register(.do_statement,
            compound(
                required("do"),
                required(.code_block),
                optional(.catch_clauses)
            )
        )
        
        // catch
        
        register(.catch_clauses,
            compound(
                required(.catch_clause),
                optional(.catch_clauses)
            )
        )
        
        register(.catch_clause,
            compound(
                required("catch"),
                optional(.pattern),
                optional(.where_clause),
                required(.code_block)
            )
        )
    }
}