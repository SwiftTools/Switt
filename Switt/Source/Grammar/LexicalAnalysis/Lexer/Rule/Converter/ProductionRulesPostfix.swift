struct ProductionRulesPostfix {
    var type: RuleCollectionType
    var rules: [ProductionRule]
    
    static var empty: ProductionRulesPostfix {
        // For empty postfix type doesn't matter
        return ProductionRulesPostfix(
            type: .Sequence,
            rules: []
        )
    }
}