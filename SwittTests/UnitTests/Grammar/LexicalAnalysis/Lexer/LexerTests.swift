import XCTest
import Nimble
@testable import Switt

class TokenOutputStreamMock: TokenOutputStream {
    var tokens: [Token] = []
    var isFinished: Bool = false
    
    func putToken(token: Token) {
        tokens.append(token)
    }
    
    func finish() {
        isFinished = true
    }
}

class LexerTests: XCTestCase {
    func testOnSimpleGrammar() {
        var lexerRules = LexerRules()
        
        lexerRules.appendRule(name: .QUESTION, rule: LexerRuleConverter.convertToLexerRule(~"?")!)
        lexerRules.appendRule(name: .MUL, rule: LexerRuleConverter.convertToLexerRule(~"*")!)
        
        let lexer = LexerImpl(
            lexerRules: lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
        )
        
        let inputStream = CharacterInputStringStream(string: "?*?*")
        let outputStream = TokenOutputStreamMock()
        
        lexer.tokenize(inputStream, outputStream: outputStream)
        
        expect(outputStream.tokens.map { $0.string }).to(equal(["?", "*", "?", "*"]))
        expect(outputStream.isFinished).to(equal(true))
    }
    
    func testXXX() {
        let grammar = SwiftGrammarFactory().grammar()
        
        let lexerRules = grammar.grammarRules.lexerRules
        
        let lexer = LexerImpl(
            lexerRules: lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
        )
        
        let inputStream = CharacterInputStringStream(string: "MyClass")
        let outputStream = TokenOutputStreamMock()
        
        lexer.tokenize(inputStream, outputStream: outputStream)
        
        let actualIdentifiers = outputStream.tokens.map { $0.ruleIdentifier }
        let expectedIdentifiers = [
            RuleIdentifier.Named(.Identifier)
        ]
        
        expect(actualIdentifiers).to(equal(expectedIdentifiers))
    }
    
    func testOnActualGrammar() {
        let grammar = SwiftGrammarFactory().grammar()
        
        let lexerRules = grammar.grammarRules.lexerRules
        
        let lexer = LexerImpl(
            lexerRules: lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(lexerRules: lexerRules)
        )
        
        let inputStream = CharacterInputStringStream(string: "class MyClass { }")
        let outputStream = TokenOutputStreamMock()
        
        lexer.tokenize(inputStream, outputStream: outputStream)
        
        let actualIdentifiers = outputStream.tokens.map { $0.ruleIdentifier }
        let expectedIdentifiers = [
            RuleIdentifier.Unnamed("class"),
            RuleIdentifier.Named(.WS),
            RuleIdentifier.Named(.Identifier),
            RuleIdentifier.Named(.WS),
            RuleIdentifier.Unnamed("{"),
            RuleIdentifier.Named(.WS),
            RuleIdentifier.Unnamed("}")
        ]
        
        expect(actualIdentifiers).to(equal(expectedIdentifiers))
    }
}