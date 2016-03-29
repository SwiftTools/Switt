class SwiftGrammarOperatorDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.operator_declaration,
            any(
                .prefix_operator_declaration,
                .postfix_operator_declaration,
                .infix_operator_declaration
            )
        )
        
        parserRule(.prefix_operator_declaration,
            compound(
                required("prefix"),
                required("operator"),
                required(._operator),
                required("{"),
                required("}")
                
            )
        )
        
        parserRule(.postfix_operator_declaration,
            compound(
                required("postfix"),
                required("operator"),
                required(._operator),
                required("{"),
                required("}")
                
            )
        )
        
        parserRule(.infix_operator_declaration,
            compound(
                required("infix"),
                required("operator"),
                required(._operator),
                required("{"),
                required(.infix_operator_attributes),
                required("}")
            )
        )
        
        parserRule(.infix_operator_attributes,
            compound(
                optional(.precedence_clause),
                optional(.associativity_clause)
            )
        )
        
        parserRule(.precedence_clause,
            compound(
                required("precedence"),
                required(.precedence_level)
            )
        )
        
        parserRule(.precedence_level,
            required(.integer_literal)
        )
        
        parserRule(.associativity_clause,
            compound(
                required("associativity"),
                required(.associativity)
            )
        )
        
        parserRule(.associativity,
            any(
                required("left"),
                required("right"),
                required("none")
            )
        )
    }
}