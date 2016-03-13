class SwiftGrammarLiteralExpressions: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.literal_expression,
            any(
                required(.literal),
                required(.array_literal),
                required(.dictionary_literal),
                required("__FILE__"),
                required("__LINE__"),
                required("__COLUMN__"),
                required("__FUNCTION__")
            )
        )
        
        // array
        
        register(.array_literal,
            compound(
                required("["),
                optional(.array_literal_items),
                required("]")
                
            )
        )
        
        register(.array_literal_items,
            compound(
                required(.array_literal_item),
                zeroOrMore(
                    required(","),
                    required(.array_literal_item)
                ),
                optional(",")
            )
        )
        
        register(.array_literal_item,
            required(.expression)
        )
        
        // dictionary
        
        register(.dictionary_literal,
            any(
                compound(
                    required("["),
                    required(.dictionary_literal_items),
                    required("]")
                ),
                compound(
                    required("["),
                    required(":"),
                    required("]")
                )
            )
        )
        
        register(.dictionary_literal_items,
            compound(
                required(.array_literal_item),
                zeroOrMore(
                    required(","),
                    required(.array_literal_item)
                ),
                optional(",")
            )
        )
        
        register(.dictionary_literal_item,
            compound(
                required(.expression),
                required(":"),
                required(.expression)
            )
        )
    }
}