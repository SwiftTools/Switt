class RepeatingProductionRuleTransformer: ProductionRuleTransformer {
    private let transformer: ProductionRuleTransformer
    private let stopCondition: ProductionRule -> Bool
    
    init(transformer: ProductionRuleTransformer, stopCondition: ProductionRule -> Bool = { _ in return false }) {
        self.transformer = transformer
        self.stopCondition = stopCondition
    }
    
    func transform(productionRule: ProductionRule) -> ProductionRule {
        var ruleBefore = productionRule
        
        while true {
            let ruleAfter = transformer.transform(ruleBefore)
            
            if stopCondition(ruleAfter) {
                return ruleAfter
            }
            
            if ruleBefore == ruleAfter {
                // transformer can't continue
                return ruleAfter
            }
            
            ruleBefore = ruleAfter
        }
    }
}