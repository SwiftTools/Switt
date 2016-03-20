struct LexerRulesPrefix {
    var type: RuleCollectionType
    var rules: [LexerRule]
    
    static var empty: ProductionRulesPostfix {
        // For empty prefix type doesn't matter
        return ProductionRulesPostfix(
            type: .Sequence,
            rules: []
        )
    }
}