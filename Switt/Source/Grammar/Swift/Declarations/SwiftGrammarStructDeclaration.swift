class SwiftGrammarStructDeclaration: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.struct_declaration,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("struct"),
                required(.struct_name),
                optional(.generic_parameter_clause),
                optional(.type_inheritance_clause),
                required(.struct_body)
            )
        )
        
        parserRule(.struct_name,
            required(.identifier)
        )
        
        parserRule(.struct_body,
            compound(
                required("{"),
                optional(.declarations),
                required("}")
            )
        )
    }
}