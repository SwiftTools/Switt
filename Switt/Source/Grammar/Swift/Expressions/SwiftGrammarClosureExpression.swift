class SwiftGrammarClosureExpression: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.closure_expression,
            compound(
                required("{"),
                optional(.closure_signature),
                required(.statements),
                required("}")
            )
        )
        
        // "expression was too complex to be solved in reasonable time",
        // so I've extracted it to an array
        let closureSignatureLexemes: [Lexeme] = [
            compound(
                required(.parameter_clause),
                optional(.function_result),
                required("in")
            ),
            compound(
                required(.identifier_list),
                optional(.function_result),
                required("in")
            ),
            compound(
                required(.capture_list),
                required(.parameter_clause),
                optional(.function_result),
                required("in")
            ),
            compound(
                required(.capture_list),
                required(.identifier_list),
                optional(.function_result),
                required("in")
            ),
            compound(
                required(.capture_list),
                required("in")
            )
        ]
        register(.closure_signature,
            any(
                closureSignatureLexemes
            )
        )
        
        register(.capture_list,
            compound(
                required("["),
                required(.capture_list_items),
                required("]")
            )
        )
        
        register(.capture_list_items,
            compound(
                required(.capture_list_item),
                zeroOrMore(
                    required(","),
                    required(.capture_list_item)
                )
            )
        )
        
        register(.capture_list_item,
            compound(
                optional(.capture_specifier),
                required(.expression)
            )
        )
        
        register(.capture_specifier,
            any(
                "weak",
                "unowned",
                "unowned(safe)",
                "unowned(unsafe)"
            )
        )
    }
}