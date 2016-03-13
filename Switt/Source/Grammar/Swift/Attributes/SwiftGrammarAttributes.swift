class SwiftGrammarAttributes: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.attribute,
            compound(
                required("@"),
                required(.attribute_name),
                optional(.attribute_argument_clause)
                
            )
        )
        
        register(.attribute_name,
            required(.identifier)
        )
        
        register(.attribute_argument_clause,
            compound(
                required("("),
                optional(.balanced_tokens),
                required(")")
            )
        )
        
        register(.attributes,
            oneOrMore(.attribute)
        )
        
        register(.balanced_tokens,
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
        register(.balanced_token,
            any(
                balancedTokenRules
            )
        )
    }
}