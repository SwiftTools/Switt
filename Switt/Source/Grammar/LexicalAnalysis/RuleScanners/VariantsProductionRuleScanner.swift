//class VariantsProductionRuleScanner: ProductionRuleScanner {
//    let productionRules: [ProductionRule]
//    let input: ProductionRuleScannerInput
//    
//    private struct MatchedRuleInfo {
//        var rule: ProductionRule
//        var position: Position
//        var result: ParserResult
//    }
//    
//    init(input: ProductionRuleScannerInput, productionRules: [ProductionRule]) {
//        self.productionRules = productionRules
//        self.input = input
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        var matchedRulesInfo: [MatchedRuleInfo] = []
//        
//        for rule in productionRules {
//            
//            let scanner = AnyProductionRuleScanner(rule: rule, input: input)
//            let result = scanner.scan(outputStream)
//            switch result {
//            case .Fail:
//                // ignore
//                break
//            default:
//                matchedRulesInfo.append(
//                    MatchedRuleInfo(
//                        rule: rule,
//                        position: input.inputStream.position,
//                        result: result
//                    )
//                )
//            }
//            
//            input.inputStream.resetPosition(position)
//        }
//        
//        matchedRulesInfo.sortInPlace({ left, right -> Bool in
//            left.position < right.position
//        })
//        let bestRule = matchedRulesInfo.last
//        
//        if let bestRule = bestRule {
//            input.inputStream.resetPosition(bestRule.position)
//            return bestRule.result
//        } else {
//            input.inputStream.resetPosition(position)
//            outputStream.logFail(input)
//            return .Fail
//        }
//    }
//}