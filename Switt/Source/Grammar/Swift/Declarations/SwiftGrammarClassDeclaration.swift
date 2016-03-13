class SwiftGrammarClassDeclaration: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.class_declaration,
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
        
        register(.class_name,
            required(.identifier)
        )
        register(.class_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}
