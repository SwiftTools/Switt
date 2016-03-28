class SwiftGrammarExpressions: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        append(SwiftGrammarLiteralExpressions())
        append(SwiftGrammarClosureExpression())
        
        parserRule(.expression,
            compound(
                optional(.try_operator),
                required(.prefix_expression),
                optional(.binary_expressions)
            )
        )
        
        parserRule(.expression_list,
            compound(
                required(.expression),
                zeroOrMore(
                    required(","),
                    required(.expression)
                )
            )
        )
        
        parserRule(.prefix_expression,
            any(
                .prefix_operator ~ .postfix_expression,
                ~.postfix_expression,
                ~.in_out_expression
            )
        )
        
        parserRule(.in_out_expression,
            compound(
                required("&"),
                required(.identifier)
            )
        )
        
        parserRule(.try_operator,
            ~"try"
                | "try" ~ "?"
                | "try" ~ "!"
        )
        
        parserRule(.binary_expression,
            .binary_operator ~ .prefix_expression
            | .conditional_operator ~ ??.try_operator ~ .prefix_expression
            | .type_casting_operator
        )
        
        parserRule(.binary_expressions,
            oneOrMore(.binary_expression)
        )
        
        parserRule(.conditional_operator,
            compound(
                required("?"),
                optional(.try_operator),
                required(.expression),
                required(":")
            )
        )
        
        parserRule(.type_casting_operator,
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
        
        parserRule(.primary_expression,
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
        
        parserRule(.implicit_member_expression,
            compound(
                required("."),
                required(.identifier)
            )
        )
        
        parserRule(.self_expression,
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
        
        parserRule(.superclass_expression,
            any(
                .superclass_method_expression,
                .superclass_subscript_expression,
                .superclass_initializer_expression
            )
        )
        
        parserRule(.superclass_method_expression,
            compound(
                required("super"),
                required("."),
                required(.identifier)
            )
        )
        
        parserRule(.superclass_subscript_expression,
            compound(
                required("super"),
                required("["),
                required(.expression),
                required("]")
            )
        )
        
        parserRule(.superclass_initializer_expression,
            compound(
                required("super"),
                required("."),
                required("init")
            )
        )
        
        //
        
        parserRule(.parenthesized_expression,
            compound(
                required("("),
                optional(.expression_element_list),
                required(")")
            )
        )
        
        parserRule(.expression_element_list,
            compound(
                required(.expression_element),
                zeroOrMore(
                    required(","),
                    required(.expression_element)
                )
            )
        )
        
        parserRule(.expression_element,
            .expression | .identifier ~ ":" ~ .expression
        )
        
        parserRule(.wildcard_expression,
            ~"_"
        )
//        
//        parserRule(.postfix_expression,
//            .postfix_expression ~ .postfix_operator // postfix_operation
//            | .postfix_expression ~ .parenthesized_expression // function_call_expression
//            | .postfix_expression ~ ??.parenthesized_expression ~ .trailing_closure // function_call_with_closure_expression
//            | .postfix_expression ~ "." ~ "init" // initializer_expression
//            | .postfix_expression ~ "." ~ .Pure_decimal_digits // explicit_member_expression1
//            | .postfix_expression ~ "." ~ .identifier ~ ??.generic_argument_clause // explicit_member_expression2
//            | .postfix_expression ~ "." ~ "self" // postfix_self_expression
//            | .postfix_expression ~ "." ~ "dynamicType" // dynamic_type_expression
//            | .postfix_expression ~ "[" ~ .expression_list ~ "]" // subscript_expression
//            | ~.primary_expression
//        )
        
        parserRule(.postfix_expression,
            ProductionRule.Alternatives(
                rules: [
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~.postfix_operator]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~.parenthesized_expression]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, optional(.parenthesized_expression), ~.trailing_closure]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~".", ~"init"]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~".", ~.Pure_decimal_digits]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~".", ~.identifier, optional(.generic_argument_clause)]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~".", ~"self"]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~".", ~"dynamicType"]),
                    ProductionRule.Sequence(rules: [~.postfix_expression, ~"[", ~.expression_list, ~"]"]),
                    ProductionRule.Sequence(rules: [~.primary_expression])
                ]
            )
        )
        
        parserRule(.trailing_closure,
            required(.closure_expression)
        )
    }
}