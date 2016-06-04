import Antlr4
import SwiftGrammar

public protocol SwiftFileParser {
    func parseFile(file: String) -> SwiftFile?
    func parseCode(code: String) -> SwiftFile?
}

public class SwiftFileParserImpl: SwiftFileParser {
    public init() {
    }
    
    public func parseFile(file: String) -> SwiftFile? {
        if NSFileManager().fileExistsAtPath(file) {
            return parseStream(ANTLRFileStream(file))
        } else {
            return nil
        }
    }
    
    public func parseCode(code: String) -> SwiftFile? {
        return parseStream(StringStream(code))
    }
    
    private func parseStream(stream: CharStream) -> SwiftFile? {
        do {
            let lexer = SwiftLexer(stream)
            let tokens = CommonTokenStream(lexer)
            let parser = try SwiftParser(tokens)
            
            let topLevel = try parser.top_level()
            
            let assembly = ConvertingAssemblyImpl()
            
            let converter = assembly.converter()
            
            let result = converter.convert(topLevel)
            
            return result
        } catch {
            return nil
        }
    }
}