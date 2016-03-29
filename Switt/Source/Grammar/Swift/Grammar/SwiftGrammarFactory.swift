// Used grammars from https://github.com/antlr
// Language reference: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AboutTheLanguageReference.html#//apple_ref/doc/uid/TP40014097-CH29-ID345

class SwiftGrammarFactory: GrammarFactory, GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func grammar() -> Grammar {
        return grammar(firstRule: RuleName.top_level)
    }
    
    func registerRules() {
        parserRule(.top_level,
            zeroOrMore(.statement)
        )
        
        append(SwiftGrammarStatements())
        append(SwiftGrammarGenericParametersAndArguments())
        append(SwiftGrammarDeclarations())
        append(SwiftGrammarPatterns())
        append(SwiftGrammarAttributes())
        append(SwiftGrammarExpressions())
        append(SwiftGrammarTypes())
        append(SwiftGrammarLexicalStructure())
    }
}