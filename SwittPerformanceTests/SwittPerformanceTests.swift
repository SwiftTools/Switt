import XCTest
@testable import Switt

class SwittPerformanceTests: XCTestCase {
    let grammar = SwiftGrammarFactory().grammar()
    
    static let file = __FILE__
    
    let fileContents = NSString(
        data: NSFileManager.defaultManager().contentsAtPath(file)!,
        encoding: NSUTF8StringEncoding
        ) as! String
    
    func testSwiftGrammarFactory() {
        measureBlock {
            let _ = SwiftGrammarFactory().grammar()
        }
    }
    
    func testLexer() {
        let inputStream = CharacterInputStringStream(string: fileContents)
        
        measureBlock { [grammar, inputStream] in
            let tokens = LexerImpl(
                lexerRules: grammar.grammarRules.lexerRules,
                tokenizerFactory: TokenizerFactoryImpl(
                    lexerRules: grammar.grammarRules.lexerRules
                )
                ).tokenize(inputStream).tokens
            
            XCTAssert(tokens.count > 0)
        }
    }
    
    func testParser() {
        let inputStream = CharacterInputStringStream(string: fileContents)
        let tokenStream = LexerImpl(
            lexerRules: grammar.grammarRules.lexerRules,
            tokenizerFactory: TokenizerFactoryImpl(
                lexerRules: grammar.grammarRules.lexerRules
            )
        ).tokenize(inputStream)
        
        measureBlock { [grammar, tokenStream] in
            let parser = ParserImpl(
                parserRules: grammar.grammarRules.parserRules,
                firstRule: grammar.firstRule
            )
            
            let tree = parser.parse(tokenStream)
            
            XCTAssert(tree != nil)
        }
    }
    
}
