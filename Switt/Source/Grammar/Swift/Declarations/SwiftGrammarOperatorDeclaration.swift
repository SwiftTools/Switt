class SwiftGrammarOperatorDeclaration: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.operator_declaration,
            any(
                .prefix_operator_declaration,
                .postfix_operator_declaration,
                .infix_operator_declaration
            )
        )
        
        register(.prefix_operator_declaration,
            compound(
                required("prefix"),
                required("operator"),
                required(._operator),
                required("{"),
                required("}")
                
            )
        )
        
        register(.postfix_operator_declaration,
            compound(
                required("postfix"),
                required("operator"),
                required(._operator),
                required("{"),
                required("}")
                
            )
        )
        
        register(.infix_operator_declaration,
            compound(
                required("infix"),
                required("operator"),
                required(._operator),
                required("{"),
                required(.infix_operator_attributes),
                required("}")
            )
        )
        
        register(.infix_operator_attributes,
            compound(
                optional(.precedence_clause),
                optional(.associativity_clause)
            )
        )
        
        register(.precedence_clause,
            compound(
                required("precedence"),
                required(.precedence_level)
            )
        )
        
        register(.precedence_level,
            required(.integer_literal)
        )
        
        register(.associativity_clause,
            compound(
                required("associativity"),
                required(.associativity)
            )
        )
        
        register(.associativity,
            any(
                required("left"),
                required("right"),
                required("none")
            )
        )
    }
}