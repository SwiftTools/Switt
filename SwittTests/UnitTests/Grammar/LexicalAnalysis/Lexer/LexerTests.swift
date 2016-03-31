import XCTest
import Nimble
@testable import Switt

private class Helper {
    static func defaultTokens(string: String) -> [Token] {
        return filteredTokens(string, filter: { token in token.channel == .Default })
    }
    
    static func allTokens(string: String) -> [Token] {
        return filteredTokens(string, filter: { _ in true })
    }
    
    static func filteredTokens(string: String, filter: Token -> Bool) -> [Token] {
        let grammar = CachedSwiftGrammarFactory.instance.grammar()
        
        let lexerRules = grammar.grammarRules.lexerRules
        
        let lexer = LexerImpl(
            lexerRules: lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
        )
        
        let inputStream = CharacterInputStringStream(string: string)
        
        return lexer.tokenize(inputStream).tokens.filter(filter)
    }
}

class LexerTests: XCTestCase {
    func testOnSimpleGrammar() {
        var lexerRules = LexerRules()
        
        let lexerRuleConverter = LexerRuleConverterImpl()
        
        lexerRules.appendRule(name: .QUESTION, rule: lexerRuleConverter.convertToLexerRule(~"?")!, channel: .Default)
        lexerRules.appendRule(name: .MUL, rule: lexerRuleConverter.convertToLexerRule(~"*")!, channel: .Default)
        
        let lexer = LexerImpl(
            lexerRules: lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
        )
        
        let inputStream = CharacterInputStringStream(string: "?*??*")
        
        expect(lexer.tokenize(inputStream).tokens.map { $0.string }).to(equal(["?", "*", "?", "?", "*"]))
    }
    
    func testXXX() {
        let grammar = CachedSwiftGrammarFactory.instance.grammar()
        
        let lexerRules = grammar.grammarRules.lexerRules
        
        let lexer = LexerImpl(
            lexerRules: lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
        )
        
        let inputStream = CharacterInputStringStream(string: "MyClass")
        
        let actualIdentifiers = lexer.tokenize(inputStream).tokens.map { $0.ruleIdentifier }
        let expectedIdentifiers = [
            RuleIdentifier.Named(.Identifier)
        ]
        
        expect(actualIdentifiers).to(equal(expectedIdentifiers))
    }
    
    func testOnActualGrammar() {
        let actualIdentifiers = Helper.allTokens("class MyClass { }").map { $0.ruleIdentifier }
        let expectedIdentifiers = [
            RuleIdentifier.Unnamed("class"),
            RuleIdentifier.Named(.WS),
            RuleIdentifier.Named(.Identifier),
            RuleIdentifier.Named(.WS),
            RuleIdentifier.Named(.LCURLY),
            RuleIdentifier.Named(.WS),
            RuleIdentifier.Named(.RCURLY)
        ]
        
        expect(actualIdentifiers).to(equal(expectedIdentifiers))
    }
    
    func testOnActualGrammar2() {
        let actualIdentifiers = Helper.defaultTokens("=1").map { $0.ruleIdentifier }
        let expectedIdentifiers = [
            RuleIdentifier.Named(.EQUAL),
            RuleIdentifier.Named(.Decimal_literal)
        ]
        
        expect(actualIdentifiers).to(equal(expectedIdentifiers))
    }
    
    func testOnActualGrammar3() {
        let actualIdentifiers = Helper.defaultTokens("= 1").map { $0.ruleIdentifier }
        let expectedIdentifiers = [
            RuleIdentifier.Named(.EQUAL),
            RuleIdentifier.Named(.Decimal_literal)
        ]
        
        expect(actualIdentifiers).to(equal(expectedIdentifiers))
    }
}