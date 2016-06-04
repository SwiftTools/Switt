import Switt
import Nimble
import Quick
import XCTest

class SwiftFileParserSpec: QuickSpec {
    override func spec() {
        describe("SwiftFileParserImpl") {
            let parser = SwiftFileParserImpl() // it is stateless
            
            it("can parse files") {
                let file = parser.parseFile(TestSwiftFile.file)
                
                print(file)
                
                expect(file?.protocols.count).to(equal(1))
                expect(file?.classes.count).to(equal(1))
            }
            
            it("can parse protocols") {
                let code = "protocol TestProtocolWithFunction { func doWork(a: Int, andB b: String, _ none: Int) throws -> [String]"
                let file = parser.parseCode(code)
                
                guard let parsedProtocol = file?.protocols.first else {
                    fail("Failed to parse protocol")
                    return
                }
                
                expect(parsedProtocol.name).to(equal("TestProtocolWithFunction"))
                expect(parsedProtocol.accessibility).to(equal(Accessibility.Internal))
                expect(parsedProtocol.funcs.count).to(equal(1))
                expect(parsedProtocol.inits.count).to(equal(0))
                expect(parsedProtocol.associatedTypes.count).to(equal(0))
                expect(parsedProtocol.vars.count).to(equal(0))
                expect(parsedProtocol.subscripts.count).to(equal(0))
                
                guard let parsedFunc = parsedProtocol.funcs.first else {
                    fail("Failed to parse protocol's func")
                    return
                }
                
                expect(parsedFunc.name).to(equal(FunctionName.Function("doWork")))
                    
                switch parsedFunc.signature.result?.type {
                case .Some(.Array(.Identifier(let typeIdentifier))):
                    expect(typeIdentifier.elements.first.name).to(equal("String"))
                    expect(typeIdentifier.elements.first.genericArguments).to(beNil())
                default:
                    fail("Failed to parse function result")
                }
                
                expect(parsedFunc.signature.throwing).to(equal(Throwing.Throws))
                expect(parsedFunc.signature.curry.count).to(equal(1))
                expect(parsedFunc.signature.parameters.count).to(equal(3))
                
                if let parameter = parsedFunc.signature.parameters.at(0) {
                    expect(parameter.externalName).to(beNil())
                    expect(parameter.localName).to(equal(ParameterName.Some("a")))
                }
                if let parameter = parsedFunc.signature.parameters.at(1) {
                    expect(parameter.externalName).to(equal(ParameterName.Some("andB")))
                    expect(parameter.localName).to(equal(ParameterName.Some("b")))
                }
                if let parameter = parsedFunc.signature.parameters.at(2) {
                    expect(parameter.externalName).to(equal(ParameterName.None))
                    expect(parameter.localName).to(equal(ParameterName.Some("none")))
                }
            }
        }
    }
}
