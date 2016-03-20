//class ReferenceProductionRuleScanner: ProductionRuleScanner {
//    let input: ProductionRuleScannerInput
//    let ruleName: RuleName
//    
//    init(input: ProductionRuleScannerInput, ruleName: RuleName) {
//        self.input = input
//        self.ruleName = ruleName
//    }
//    
//    // returns true if everything is fine
//    private func checkParserRuleInLexerRule(
//        inContext inContext: RuleContext,
//        context: RuleContext,
//        outputStream: ProductionRuleScannerOutputStream
//        ) -> Bool
//    {
//        switch (context, inContext) {
//        case (.Parser, .Lexer):
//            outputStream.errorStream.parserRuleInsideLexerRule(ruleName, position: input.inputStream.position)
//            return false
//        default:
//            return true
//        }
//    }
//    
//    private func scan(
//        outputStream: ProductionRuleScannerOutputStream,
//        rule: ProductionRule,
//        isFragment: Bool
//        ) -> ParserResult
//    {
//        let position = input.inputStream.position
//        
//        var subinput = input
//        
//        if subinput.rulesThatCanCauseRecursion.contains(ruleName) {
//            // Detected left recursion, it is not an error in grammar.
//            // If this rule is among others in any(...) other rules,
//            // rule without recursion will be used first.
//            // Left recursion breaks for second (and so not leftmost) rule in compound(...)
//            
//            // TODO: that can be really an error. Assume this rule: type -> type
//            // TODO: report this error
//            
//            return .Fail
//        } else {
//            subinput.rulesThatCanCauseRecursion.insert(ruleName)
//            subinput.ruleContext = input.grammar.contextCheckFunction(ruleName)
//            
//            let checkParserSuccess = checkParserRuleInLexerRule(
//                inContext: input.ruleContext,
//                context: subinput.ruleContext,
//                outputStream: outputStream)
//            
//            if !checkParserSuccess {
//                return .Fail
//            } else {
//                let scanner = AnyProductionRuleScanner(rule: rule, input: subinput)
//                let parserResult = scanner.scan(outputStream)
//                
//                if isFragment {
//                    switch parserResult {
//                    case .Fail:
//                        input.inputStream.resetPosition(position)
//                        outputStream.logFail(input)
//                        return .Fail
//                    default:
//                        return parserResult
//                    }
//                } else {
//                    let nodes: [ParseTreeNode]
//                    
//                    switch parserResult {
//                    case .Fail:
//                        input.inputStream.resetPosition(position)
//                        outputStream.logFail(input)
//                        return .Fail
//                    case .Nodes(let subnodes):
//                        nodes = subnodes
//                    case .Success:
//                        nodes = []
//                    case .Terminal(let terminal):
//                        nodes = [ParseTreeNode.Leaf(terminal)]
//                    case .Tree(let tree):
//                        nodes = [ParseTreeNode.Tree(tree)]
//                    }
//                    
//                    let tree = ParseTree(name: ruleName, nodes: nodes)
//                    
//                    return ParserResult.Tree(tree)
//                }
//            }
//        }
//    }
//    
//    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
//        let position = input.inputStream.position
//        
//        if let rule = input.grammar.rules.rules[ruleName] {
//            return scan(outputStream, rule: rule, isFragment: false)
//        } else if let fragment = input.grammar.rules.fragments[ruleName] {
//            return scan(outputStream, rule: fragment, isFragment: true)
//        } else {
//            outputStream.errorStream.canNotFindRule(ruleName, position: input.inputStream.position)
//            input.inputStream.resetPosition(position)
//            outputStream.logFail(input)
//            return .Fail
//        }
//    }
//}