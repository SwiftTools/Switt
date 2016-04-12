import SwiftGrammar
import Antlr4

class ThrowingFromTerminalsConverter {
    static func convert(context: ParserRuleContext) -> Throwing? {
        return context.mapTerminal(
            [
                SwiftParser.SYM_THROWS: Throwing.Throws,
                SwiftParser.SYM_RETHROWS: Throwing.Rethrows
            ]
        )
    }
}