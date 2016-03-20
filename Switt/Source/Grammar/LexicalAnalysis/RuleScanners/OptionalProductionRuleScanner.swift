//class OptionalProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    let rule: ProductionRule
//    
//    init(input: ProductionRuleScannerInput, rule: ProductionRule) {
//        self.input = input
//        self.rule = rule
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        let scanner = AnyProductionRuleScanner(rule: rule, input: input)
//        let result = scanner.scan(outputStream)
//        switch result {
//        case .Fail:
//            input.inputStream.resetPosition(position)
//            return .Success
//        default:
//            return result
//        }
//    }
//}
