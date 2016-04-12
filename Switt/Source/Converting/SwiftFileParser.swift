import Antlr4
import SwiftGrammar

protocol SwiftFileParser {
    func parse(file: String) -> SwiftFile?
}

class SwiftFileParserImpl: SwiftFileParser {
    func parse(file: String) -> SwiftFile? {
        do {
            if NSFileManager().fileExistsAtPath(file) {
                let lexer = SwiftLexer(ANTLRFileStream(file))
                let tokens = CommonTokenStream(lexer)
                let parser = try SwiftParser(tokens)
                
                let topLevel = try parser.top_level()
                
                let assembly = ConvertingAssemblyImpl()
                
                let converter = assembly.converter()
                
                let result = converter.convert(topLevel)
                
                return result
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}