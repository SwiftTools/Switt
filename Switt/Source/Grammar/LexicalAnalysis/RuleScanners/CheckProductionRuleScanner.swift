//class CheckProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    let checkFunction: ProductionRuleCheckFunction
//    
//    init(input: ProductionRuleScannerInput, checkFunction: ProductionRuleCheckFunction) {
//        self.input = input
//        self.checkFunction = checkFunction
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        if checkFunction() {
//            return .Success
//        } else {
//            input.inputStream.resetPosition(position)
//            outputStream.logFail(input)
//            return .Fail
//        }
//    }
//}