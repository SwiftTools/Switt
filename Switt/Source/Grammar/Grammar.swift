// Used grammars from https://github.com/antlr
// Language reference: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AboutTheLanguageReference.html#//apple_ref/doc/uid/TP40014097-CH29-ID345

class SwiftGrammar: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        register(.top_level,
            compound(
                zeroOrMore(.statement),
                eof()
            )
        )
        
        append(SwiftGrammarTypes())
        append(SwiftGrammarExpressions())
        append(SwiftGrammarStatements())
        append(SwiftGrammarDeclarations())
        append(SwiftGrammarAttributes())
        append(SwiftGrammarPatterns())
        append(SwiftGrammarGenericParametersAndArguments())
    }
}