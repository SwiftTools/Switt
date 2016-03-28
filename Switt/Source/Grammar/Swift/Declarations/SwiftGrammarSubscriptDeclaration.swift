class SwiftGrammarSubscriptDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.subscript_declaration,
            any(
                compound(
                    required(.subscript_head),
                    required(.subscript_result),
                    required(.code_block)
                ),
                compound(
                    required(.subscript_head),
                    required(.subscript_result),
                    required(.getter_setter_block)
                ),
                compound(
                    required(.subscript_head),
                    required(.subscript_result),
                    required(.getter_setter_keyword_block)
                )
            )
        )
        
        parserRule(.subscript_head,
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("subscript"),
                required(.parameter_clause)
            )
        )
        parserRule(.subscript_result,
            compound(
                required(.arrow_operator),
                optional(.attributes),
                required(.type)
            )
        )

    }
}