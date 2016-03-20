//class CharRangesProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    let positive: Bool
//    let ranges: [CharRange]
//    
//    init(input: ProductionRuleScannerInput, positive: Bool, ranges: [CharRange]) {
//        self.input = input
//        self.positive = positive
//        self.ranges = ranges
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        if let streamCharacter = input.inputStream.getCharacter() {
//            if positive {
//                for range in ranges {
//                    if range.contains(streamCharacter) {
//                        input.inputStream.moveNext()
//                        return .Terminal(String(streamCharacter))
//                    }
//                }
//                outputStream.logFail(input)
//                return .Fail
//            } else {
//                for range in ranges {
//                    if range.contains(streamCharacter) {
//                        outputStream.logFail(input)
//                        return .Fail
//                    }
//                }
//                input.inputStream.moveNext()
//                return .Terminal(String(streamCharacter))
//            }
//        } else {
//            outputStream.logFail(input)
//            return .Fail
//        }
//    }
//}