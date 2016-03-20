class SwiftGrammarLiteralExpressions: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.literal_expression,
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
        
        parserRule(.array_literal,
            compound(
                required("["),
                optional(.array_literal_items),
                required("]")
                
            )
        )
        
        parserRule(.array_literal_items,
            compound(
                required(.array_literal_item),
                zeroOrMore(
                    required(","),
                    required(.array_literal_item)
                ),
                optional(",")
            )
        )
        
        parserRule(.array_literal_item,
            required(.expression)
        )
        
        // dictionary
        
        parserRule(.dictionary_literal,
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
        
        parserRule(.dictionary_literal_items,
            compound(
                required(.array_literal_item),
                zeroOrMore(
                    required(","),
                    required(.array_literal_item)
                ),
                optional(",")
            )
        )
        
        parserRule(.dictionary_literal_item,
            compound(
                required(.expression),
                required(":"),
                required(.expression)
            )
        )
    }
}