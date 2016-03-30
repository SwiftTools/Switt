import XCTest
import Nimble
import FileKit

@testable import Switt

private let lexicalAnalyzer = LexicalAnalyzerImpl(grammarFactory: CachedSwiftGrammarFactory.instance)

private func testFile(file: TextFile) -> Bool {
    do {
        let contents: String = try file.read()
        let tree = lexicalAnalyzer.analyze(contents)
        
        expect(tree).toNot(beNil(), description: "Can not parse file at \(file.path)")
        
        return tree != nil
    } catch let exception {
        fail("Unexpected exception: \(exception)")
        return false
    }
}

class TestLexicalAnalyzerOnProjectFilesTests: XCTestCase {
    func test() {
        var folder = Path(#file).parent
        let rootFilename = "Switt.xcodeproj"
        
        while !(folder.contains { $0.fileName == rootFilename }) {
            folder = folder.parent
        }
        
        let rootFolder = folder
        
        let files = rootFolder.find { (path) -> Bool in
            path.pathExtension == "swift"
        }
        
        let startDate = NSDate()
        let timeout: NSTimeInterval = 40
        var fails = 0
        var testedFiles = 0
        for file in (files.map { TextFile(path: $0) }) {
            testedFiles += 1
            
            if !testFile(file) {
                fails += 1
                
                if NSDate().timeIntervalSinceDate(startDate) > timeout {
                    break
                }
            }
        }
        
        if fails > 0 {
            // Nice log
            fail("Lexical analyzer failed to parse \(fails) of \(testedFiles) files")
        }
    }
}