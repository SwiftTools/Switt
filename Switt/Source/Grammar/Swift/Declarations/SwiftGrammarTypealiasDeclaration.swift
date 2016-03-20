class SwiftGrammarTypealiasDeclaration: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.typealias_declaration,
            compound(
                required(.typealias_head),
                required(.typealias_assignment)
            )
        )
        
        parserRule(.typealias_head,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("typealias"),
                required(.typealias_name)
            )
        )
        
        parserRule(.typealias_name,
            required(.identifier)
        )
        
        parserRule(.typealias_assignment,
            compound(
                .assignment_operator,
                .type
            )
        )
    }
}