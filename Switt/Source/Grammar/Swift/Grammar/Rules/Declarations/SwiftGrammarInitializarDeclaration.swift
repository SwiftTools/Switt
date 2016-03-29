class SwiftGrammarInitializarDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.initializer_declaration,
            any(
                compound(
                    required(.initializer_head),
                    optional(.generic_parameter_clause),
                    required(.parameter_clause),
                    optional("throws"),
                    required(.initializer_body)
                ),
                compound(
                    required(.initializer_head),
                    optional(.generic_parameter_clause),
                    required(.parameter_clause),
                    required("rethrows"),
                    required(.initializer_body)
                )
            )
        )
        
        let initializerHeadRules : [ProductionRule] = [
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("init")
            ),
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("init"),
                required("?")
            ),
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("init"),
                required("!")
            )
        ]
        parserRule(.initializer_head,
            any(
                initializerHeadRules
            )
        )
        
        parserRule(.initializer_body,
            required(.code_block)
        )
    }
}