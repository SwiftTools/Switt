class SwiftGrammarDeinitializerDeclaration: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
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