class SwiftGrammarClosureExpression: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.closure_expression,
            compound(
                required("{"),
                optional(.closure_signature),
                required(.statements),
                required("}")
            )
        )
        
        // "expression was too complex to be solved in reasonable time",
        // so I've extracted it to an array
        let closureSignatureRules: [ProductionRule] = [
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
        parserRule(.closure_signature,
            any(
                closureSignatureRules
            )
        )
        
        parserRule(.capture_list,
            compound(
                required("["),
                required(.capture_list_items),
                required("]")
            )
        )
        
        parserRule(.capture_list_items,
            compound(
                required(.capture_list_item),
                zeroOrMore(
                    required(","),
                    required(.capture_list_item)
                )
            )
        )
        
        parserRule(.capture_list_item,
            compound(
                optional(.capture_specifier),
                required(.expression)
            )
        )
        
        parserRule(.capture_specifier,
            any(
                "weak",
                "unowned",
                "unowned(safe)",
                "unowned(unsafe)"
            )
        )
    }
}