class LexicalAnalyzer {
    func analyze(string: String, grammar: Grammar, firstRule: RuleName? = nil) -> LexicalAnalysisResult {
//        let firstRule = firstRule ?? grammar.firstRule
//        
//        let lexerRules = LexerRules()
//        let lexer = Lexer(
//            lexerRules: lexerRules,
//            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
//        )
//        
//        if let rule = grammar.rules.rules[firstRule] ?? grammar.rules.fragments[firstRule] {
//            let input = ProductionRuleScannerInput(
//                inputStream: InputStringStream(string: string),
//                grammar: grammar,
//                ruleContext: grammar.contextCheckFunction(firstRule),
//                rulesThatCanCauseRecursion: Set([firstRule]),
//                tokens: []
//            )
//            
//            let ruleWithEof = GrammarRulesMath.compound([rule, ProductionRule.Eof])
//            
//            let scanner = AnyProductionRuleScanner(rule: ruleWithEof, input: input)
//            let outputStream = ProductionRuleScannerOutputStream()
//            return scanner.scan(outputStream)
//        }
//        
        return .Fail
    }
}