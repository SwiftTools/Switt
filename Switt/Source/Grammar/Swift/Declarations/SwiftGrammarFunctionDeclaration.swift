class SwiftGrammarFunctionDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.function_declaration,
            compound(
                required(.function_head),
                required(.function_name),
                optional(.generic_parameter_clause),
                required(.function_signature),
                optional(.function_body)
            )
        )
        
        parserRule(.function_head,
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("func")
            )
        )
        
        parserRule(.function_name,
            compound(
                required(.identifier),
                required(._operator)
            )
        )
        
        parserRule(.function_signature,
            any(
                compound(
                    required(.parameter_clauses),
                    optional("throws"),
                    optional(.function_result)
                ),
                compound(
                    required(.parameter_clauses),
                    optional("rethrows"),
                    optional(.function_result)
                )
            )
        )
        
        parserRule(.function_result,
            compound(
                required(.arrow_operator),
                optional(.attributes),
                required(.type)
            )
        )
        
        parserRule(.function_body,
            required(.code_block)
        )
        
        parserRule(.parameter_clauses,
            compound(
                required(.parameter_clause),
                optional(.parameter_clauses)
            )
        )
        
        parserRule(.parameter_clause,
            any(
                compound(
                    required("("),
                    required(")")
                ),
                compound(
                    required("("),
                    required(.parameter_list),
                    required(")")
                )
            )
        )
        
        parserRule(.parameter_list,
            compound(
                required(.parameter),
                zeroOrMore(
                    required(","),
                    required(.parameter)
                )
            )
        )
        
        let paramaterRules: [ProductionRule] = [
            compound(
                required("let"),
                optional(.external_parameter_name),
                required(.local_parameter_name),
                optional(.type_annotation),
                optional(.default_argument_clause)
            ),
            compound(
                required("var"),
                optional(.external_parameter_name),
                required(.local_parameter_name),
                optional(.type_annotation),
                optional(.default_argument_clause)
            ),
            compound(
                required("inout"),
                optional(.external_parameter_name),
                required(.local_parameter_name),
                required(.type_annotation)
            ),
            compound(
                optional(.external_parameter_name),
                required(.local_parameter_name),
                required(.type_annotation),
                required(.range_operator)
            )
        ]
        parserRule(.parameter,
            any(
                paramaterRules
            )
        )
        
        parserRule(.external_parameter_name,
            any(
                required(.identifier),
                required("_")
            )
        )
        
        parserRule(.local_parameter_name,
            any(
                required(.identifier),
                required("_")
            )
        )
        
        parserRule(.default_argument_clause,
            compound(
                .assignment_operator,
                .expression
            )
        )
    }
}