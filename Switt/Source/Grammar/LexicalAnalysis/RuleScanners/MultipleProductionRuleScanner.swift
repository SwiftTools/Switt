//class MultipleProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    let atLeast: UInt
//    let rule: ProductionRule
//    
//    init(input: ProductionRuleScannerInput, atLeast: UInt, rule: ProductionRule) {
//        self.input = input
//        self.atLeast = atLeast
//        self.rule = rule
//    }
//    
//    func scanOnce(outputStream: ProductionRuleScannerOutputStream, inout nodes: [ParseTreeNode]) -> Bool {
//        let scanner = AnyProductionRuleScanner(rule: rule, input: input)
//        
//        let result = scanner.scan(outputStream)
//        
//        switch result {
//        case .Fail:
//            outputStream.logFail(input)
//            return false
//        case .Nodes(let subnodes):
//            nodes.appendContentsOf(subnodes)
//        case .Success:
//            // ok, do nothing
//            break
//        case .Terminal(let terminal):
//            nodes.append(ParseTreeNode.Leaf(terminal))
//        case .Tree(let tree):
//            nodes.append(ParseTreeNode.Tree(tree))
//        }
//        
//        return true
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        var nodes = [ParseTreeNode]()
//        
//        for _ in 0..<atLeast {
//            if !scanOnce(outputStream, nodes: &nodes) {
//                input.inputStream.resetPosition(position)
//                return .Fail
//            }
//        }
//        
//        while true {
//            let position = input.inputStream.position
//            
//            if !scanOnce(outputStream, nodes: &nodes) {
//                input.inputStream.resetPosition(position)
//                break
//            }
//        }
//        
//        return ParserResult.Nodes(nodes)
//    }
//}