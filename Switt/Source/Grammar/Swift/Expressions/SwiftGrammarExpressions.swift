class SwiftGrammarExpressions: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.expression,
            compound(
                optional(.try_operator),
                required(.prefix_expression),
                optional(.binary_expressions)
                
            )
        )
        
        register(.expression_list,
            compound(
                required(.expression),
                zeroOrMore(
                    required(","),
                    required(.expression)
                )
            )
        )
        
        register(.prefix_expression,
            compound(
                .prefix_operator,
                .postfix_expression,
                .postfix_expression,
                .in_out_expression
            )
        )
        
        register(.in_out_expression,
            compound(
                required("&"),
                required(.identifier)
            )
        )
        
        register(.try_operator,
            any(
                required("try"),
                compound(
                    "try",
                    "?"
                ),
                compound(
                    "try",
                    "!"
                )
            )
        )
        
        register(.binary_expression,
            any(
                compound(
                    required(.binary_operator),
                    required(.prefix_expression)
                ),
                compound(
                    required(.conditional_operator),
                    optional(.try_operator)
                ),
                required(.prefix_expression),
                required(.type_casting_operator)
            )
        )
        
        register(.binary_expressions,
            oneOrMore(.binary_expression)
        )
        
        register(.conditional_operator,
            compound(
                required("?"),
                optional(.try_operator),
                required(.expression),
                required(":")
                
            )
        )
        
        register(.type_casting_operator,
            any(
                compound(
                    required("is"),
                    required(.type)
                ),
                compound(
                    required("as"),
                    required(.type)
                ),
                compound(
                    required("as?"),
                    required(.type)
                ),
                compound(
                    required("as!"),
                    required(.type)
                )
            )
        )
        
        register(.primary_expression,
            any(
                compound(
                    required(.identifier),
                    optional(.generic_argument_clause)
                ),
                required(.literal_expression),
                required(.self_expression),
                required(.superclass_expression),
                required(.closure_expression),
                required(.parenthesized_expression),
                required(.implicit_member_expression),
                required(.wildcard_expression)
            )
        )
        
        register(.implicit_member_expression,
            compound(
                required("."),
                required(.identifier)
            )
        )
        
        register(.self_expression,
            any(
                required("self"),
                compound(
                    required("self"),
                    required("."),
                    required(.identifier)
                ),
                compound(
                    required("self"),
                    required("["),
                    required(.expression_list),
                    required("]")
                ),
                compound("self", ".", "init")
            )
        )
        
        register(.superclass_expression,
            any(
                .superclass_method_expression,
                .superclass_subscript_expression,
                .superclass_initializer_expression
            )
        )
        
        register(.superclass_method_expression,
            compound(
                required("super"),
                required("."),
                required(.identifier)
            )
        )
        
        register(.superclass_subscript_expression,
            compound(
                required("super"),
                required("["),
                required(.expression),
                required("]")
            )
        )
        
        register(.superclass_initializer_expression,
            compound(
                required("super"),
                required("."),
                required("init")
            )
        )
        
        //
        
        register(.parenthesized_expression,
            compound(
                required("("),
                optional(.expression_element_list),
                required(")")
            )
        )
        
        register(.expression_element_list,
            compound(
                required(.expression_element),
                zeroOrMore(
                    required(","),
                    required(.expression_element)
                )
            )
        )
        
        register(.expression_element,
            any(
                required(.expression),
                compound(
                    required(.identifier),
                    required(":"),
                    required(.expression)
                )
            )
        )
        
        register(.wildcard_expression,
            required("_")
        )
        
        let postfixExpressionLexemes: [Lexeme] = [
            required(.postfix_operator),
            required(.parenthesized_expression),
            compound(
                optional(.parenthesized_expression),
                required(.trailing_closure)
            ),
            compound(
                required("."),
                any(
                    required(.Pure_decimal_digits),
                    compound(
                        required(.identifier),
                        optional(.generic_argument_clause)
                    ),
                    required("self"),
                    required("dynamicType")
                )
            ),
            compound(
                required("["),
                required(.expression_list),
                required("]")
            ),
            required("!"),
            required("?")
        ]
        
        register(.postfix_expression,
            compound(
                required(.primary_expression),
                any(
                    postfixExpressionLexemes
                )
            )
        )
        register(.trailing_closure,
            required(.closure_expression)
        )
    }
}