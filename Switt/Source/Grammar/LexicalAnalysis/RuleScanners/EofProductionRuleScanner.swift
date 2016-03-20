//class EofProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    
//    init(input: ProductionRuleScannerInput) {
//        self.input = input
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        if input.inputStream.getCharacter() == nil {
//            return .Success
//        } else {
//            outputStream.logFail(input)
//            return .Fail
//        }
//    }
//}