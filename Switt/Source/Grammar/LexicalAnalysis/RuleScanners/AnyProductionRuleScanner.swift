//class AnyProductionRuleScanner: ProductionRuleScanner {
//    let rule: ProductionRule
//    let input: ProductionRuleScannerInput
//    
//    init(rule: ProductionRule, input: ProductionRuleScannerInput) {
//        self.rule = rule
//        self.input = input
//    }
//    
//    @warn_unused_result
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        let scanner: ProductionRuleScanner
//        
//        switch rule {
//        case .CharRanges(let positive, let ranges):
//            scanner = CharRangesProductionRuleScanner(
//                input: input,
//                positive: positive,
//                ranges: ranges
//            )
//        case .Check(let checkFunction):
//            scanner = CheckProductionRuleScanner(
//                input: input,
//                checkFunction: checkFunction
//            )
//        case .Compound(let productionRules):
//            scanner = CompoundProductionRuleScanner(
//                input: input,
//                productionRules: productionRules
//            )
//        case .Empty:
//            scanner = EmptyProductionRuleScanner()
//        case .Eof:
//            scanner = EofProductionRuleScanner(
//                input: input
//            )
//        case .Multiple(let atLeast, let rule):
//            scanner = MultipleProductionRuleScanner(
//                input: input,
//                atLeast: atLeast,
//                rule: rule
//            )
//        case .Optional(let optionalRule):
//            scanner = OptionalProductionRuleScanner(
//                input: input,
//                rule: optionalRule
//            )
//        case .Or(let productionRules):
//            scanner = VariantsProductionRuleScanner(
//                input: input,
//                productionRules: productionRules
//            )
//        case .Reference(let ruleName):
//            scanner = ReferenceProductionRuleScanner(input: input, ruleName: ruleName)
//        case .Terminal(let terminal):
//            scanner = TerminalProductionRuleScanner(
//                input: input,
//                terminal: terminal
//            )
//        }
//        
//        let result = scanner.scan(outputStream)
//        
//        switch result {
//        case .Fail:
//            input.inputStream.resetPosition(position)
//            outputStream.logFail(input)
//            return .Fail
//        default:
//            return result
//        }
//    }
//}
