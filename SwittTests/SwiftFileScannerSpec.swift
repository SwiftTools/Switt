//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import Quick
import Nimble
@testable import Switt
import SwiftFelisCatus

class SwiftFileScannerSpec: QuickSpec {
    override func spec() {
        describe("SwiftFileScanner") {
            var swiftFileScanner: SwiftFileScanner!
            
            beforeEach {
                swiftFileScanner = SwiftFileScanner(
                    path: TestSwiftFile.file,
                    logger: SourceKitStructureScanningLoggerMock(),
                    reader: SourceKitFileReader()
                )
            }
            
            it("scans swift files and provide declarations") {
                let declarations = swiftFileScanner.scanDeclarations()
                
                expect(declarations.classes.count).to(beGreaterThan(0))
            }
            
            it("can scan function with parameters") {
                let declarations = swiftFileScanner.scanDeclarations()
                
                guard let classDeclaration = (declarations.classes.filter { $0.name == "TestSwiftFileWithFunction" }).first else {
                    fail("can not find class declaration")
                    return
                }
                
                guard let instanceMethod = classDeclaration.instanceMethods.first else {
                    fail("can not find instance method declaration")
                    return
                }
                
                guard let firstParameter = instanceMethod.parameters.first, lastParameter = instanceMethod.parameters.last else {
                    fail("can not find parameters")
                    return
                }
                
                expect(instanceMethod.name).to(equal("doWork"))
                expect(instanceMethod.nameAndArguments).to(equal("doWork(_:andB:)"))
                expect(instanceMethod.returnType).to(equal("[String]"))
                
                expect(firstParameter.externalName).to(beNil())
                expect(firstParameter.localName).to(equal("a"))
                expect(firstParameter.type).to(equal("Int"))
                
                expect(lastParameter.externalName).to(equal("andB"))
                expect(lastParameter.localName).to(equal("b"))
                expect(lastParameter.type).to(equal("String"))
            }
        }
    }
}
