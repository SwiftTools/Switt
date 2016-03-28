class SwiftGrammarAttributes: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.attribute,
            compound(
                required("@"),
                required(.attribute_name),
                optional(.attribute_argument_clause)
                
            )
        )
        
        parserRule(.attribute_name,
            required(.identifier)
        )
        
        parserRule(.attribute_argument_clause,
            compound(
                required("("),
                optional(.balanced_tokens),
                required(")")
            )
        )
        
        parserRule(.attributes,
            oneOrMore(.attribute)
        )
        
        parserRule(.balanced_tokens,
            oneOrMore(.balanced_token)
        )
        
        let balancedTokenRules: [ProductionRule] = [
            compound(
                required("("),
                optional(.balanced_tokens),
                required(")")
            ),
            compound(
                required("["),
                optional(.balanced_tokens),
                required("]")
            ),
            compound(
                required("{"),
                optional(.balanced_tokens),
                required("}")
            ),
            required(.identifier),
            required(.expression),
            required(.context_sensitive_keyword),
            required(.literal),
            required(._operator)
        ]
        parserRule(.balanced_token,
            any(
                balancedTokenRules
            )
        )
    }
}