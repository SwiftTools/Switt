class SwiftGrammarInitializarDeclaration: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.initializer_declaration,
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
        register(.initializer_head,
            any(
                initializerHeadRules
            )
        )
        
        register(.initializer_body,
            required(.code_block)
        )
    }
}