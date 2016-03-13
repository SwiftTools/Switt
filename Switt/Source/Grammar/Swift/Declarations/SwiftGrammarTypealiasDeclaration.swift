class SwiftGrammarTypealiasDeclaration: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.typealias_declaration,
            compound(
                required(.typealias_head),
                required(.typealias_assignment)
            )
        )
        
        register(.typealias_head,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("typealias"),
                required(.typealias_name)
            )
        )
        
        register(.typealias_name,
            required(.identifier)
        )
        
        register(.typealias_assignment,
            compound(
                .assignment_operator,
                .type
            )
        )
    }
}