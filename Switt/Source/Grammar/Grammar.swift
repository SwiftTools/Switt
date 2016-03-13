// Used grammars from https://github.com/antlr
// Language reference: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AboutTheLanguageReference.html#//apple_ref/doc/uid/TP40014097-CH29-ID345

protocol GrammarFactory {
    func grammar() -> Grammar
}

class SwiftGrammarRulesBuilder: GrammarFactory, GrammarRulesBuilder {
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
            rules: grammarRules,
            delimiter: any(.WS, .Block_comment, .Line_comment),
            contextCheckFunction: SwiftGrammarRulesBuilder.contextCheckFunction
        )
    }
    
    func registerRules() {
        register(.top_level,
            compound(
                zeroOrMore(.statement),
                eof()
            )
        )
        
        append(SwiftGrammarLexicalStructure())
        append(SwiftGrammarTypes())
        append(SwiftGrammarExpressions())
        append(SwiftGrammarStatements())
        append(SwiftGrammarDeclarations())
        append(SwiftGrammarAttributes())
        append(SwiftGrammarPatterns())
        append(SwiftGrammarGenericParametersAndArguments())
    }
}