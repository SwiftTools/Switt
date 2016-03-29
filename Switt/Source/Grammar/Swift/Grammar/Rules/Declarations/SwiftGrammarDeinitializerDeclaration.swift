class SwiftGrammarDeinitializerDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.deinitializer_declaration,
            compound(
                optional(.attributes),
                required("deinit"),
                required(.code_block)
            )
        )
    }
}