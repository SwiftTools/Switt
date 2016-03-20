//class TerminalProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    let terminal: String
//    
//    init(input: ProductionRuleScannerInput, terminal: String) {
//        self.input = input
//        self.terminal = terminal
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        for character in terminal.characters {
//            let streamCharacter = input.inputStream.getCharacter()
//            input.inputStream.moveNext()
//            
//            if character != streamCharacter {
//                input.inputStream.resetPosition(position)
//                outputStream.logFail(input)
//                return .Fail
//            }
//        }
//        return .Terminal(terminal)
//    }
//}