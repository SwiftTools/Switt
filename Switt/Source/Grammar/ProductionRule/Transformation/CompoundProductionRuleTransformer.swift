class CompoundProductionRuleTransformer: ProductionRuleTransformer {
    private let transformers: [ProductionRuleTransformer]
    
    init(transformers: [ProductionRuleTransformer]) {
        self.transformers = transformers
    }
    
    func transform(productionRule: ProductionRule) -> ProductionRule {
        return transformers.reduce(productionRule) { rule, transformer in
            transformer.transform(rule)
        }
    }
}