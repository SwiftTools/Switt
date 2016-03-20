//class CompoundProductionRuleScanner: ProductionRuleScanner {
//    let productionRules: [ProductionRule]
//    let input: ProductionRuleScannerInput
//    
//    init(input: ProductionRuleScannerInput, productionRules: [ProductionRule]) {
//        self.productionRules = productionRules
//        self.input = input
//    }
//    
//    private func skipDelimiters() {
//        if input.ruleContext == .Parser {
//            // For parsers check for delimiters between tokens
//            let scanner = AnyProductionRuleScanner(rule: input.grammar.delimiter, input: input)
//            let ignore = ProductionRuleScannerOutputStream()
//            let _ = scanner.scan(ignore)
//        }
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        var nodes = [ParseTreeNode]()
//        
//        skipDelimiters()
//        
//        var currentRuleIsLeftMostRule: Bool = true
//        
//        for rule in productionRules {
//            let subinput: ProductionRuleScannerInput
//            if currentRuleIsLeftMostRule {
//                subinput = input
//            } else {
//                var inputWithoutRecursion = input
//                inputWithoutRecursion.rulesThatCanCauseRecursion.removeAll()
//                subinput = inputWithoutRecursion
//            }
//            
//            let scanner = AnyProductionRuleScanner(rule: rule, input: subinput)
//            
//            switch scanner.scan(outputStream) {
//            case .Fail:
//                input.inputStream.resetPosition(position)
//                outputStream.logFail(input)
//                return .Fail
//            case .Nodes(let subnodes):
//                nodes.appendContentsOf(subnodes)
//            case .Success:
//                // nothing to do
//                break
//            case .Terminal(let terminal):
//                nodes.append(ParseTreeNode.Leaf(terminal))
//            case .Tree(let tree):
//                nodes.append(ParseTreeNode.Tree(tree))
//            }
//            
//            skipDelimiters()
//            
//            currentRuleIsLeftMostRule = false
//        }
//        
//        return .Nodes(nodes)
//    }
//}