class SwiftGrammarExtensionDeclaration: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.extension_declaration,
            compound(
                optional(.access_level_modifier),
                required("extension"),
                required(.type_identifier),
                optional(.type_inheritance_clause),
                required(.extension_body)
            )
        )
        parserRule(.extension_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}