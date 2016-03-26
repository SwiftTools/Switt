// Used grammars from https://github.com/antlr
// Language reference: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AboutTheLanguageReference.html#//apple_ref/doc/uid/TP40014097-CH29-ID345

protocol GrammarFactory {
    func grammar() -> Grammar
}

class SwiftGrammarFactory: GrammarFactory, GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    static func contextCheckFunction(ruleName: RuleName) -> RuleContext {
        let uppercaseLetters = CharRange(
            first: UnicodeScalar("A").value,
            last: UnicodeScalar("Z").value
        )
        let ruleNameString = ruleName.rawValue
        let firstCharacter = ruleNameString.characters[ruleNameString.startIndex]
        
        if uppercaseLetters.contains(firstCharacter) {
            return RuleContext.Lexer
        } else {
            return RuleContext.Parser
        }
    }
    
    func grammar() -> Grammar {
        clearRules()
        registerRules()
        
        return Grammar(
            grammarRules: grammarRules,
            firstRule: RuleName.top_level
        )
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