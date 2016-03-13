class SwiftGrammarDeinitializerDeclaration: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.deinitializer_declaration,
            compound(
                optional(.attributes),
                required("deinit"),
                required(.code_block)
            )
        )
    }
}