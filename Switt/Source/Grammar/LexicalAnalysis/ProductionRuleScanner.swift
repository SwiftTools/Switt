protocol ProductionRuleScanner {
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult
}