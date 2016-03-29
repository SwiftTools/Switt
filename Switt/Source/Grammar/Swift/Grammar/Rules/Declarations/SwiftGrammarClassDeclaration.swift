class SwiftGrammarClassDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.class_declaration,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("class"),
                required(.class_name),
                optional(.generic_parameter_clause),
                optional(.type_inheritance_clause),
                required(.class_body)
            )
        )
        
        parserRule(.class_name,
            required(.identifier)
        )
        parserRule(.class_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}
