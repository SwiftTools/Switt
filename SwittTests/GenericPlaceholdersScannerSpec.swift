//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import Quick
import Nimble
@testable import Switt

class GenericPlaceholdersScannerSpec: QuickSpec {
    override func spec() {
        describe("GenericPlaceholdersScanner") {
            var genericPlaceholdersScanner: GenericPlaceholdersScanner!
            
            beforeEach {
                genericPlaceholdersScanner = GenericPlaceholdersScanner()
            }
            
            describe("scanGenericPlaceholdersInFunctionName") {
                it("searches and scans for generic placeholders inside <> in function name that Source Kit provides") {
                    let functionName = "functionName<T, U: CollectionType where U.Generator.Element == T>(u: U)"
                    let genericPlaceholders: GenericPlaceholders
                    genericPlaceholders = genericPlaceholdersScanner.scanGenericPlaceholdersInFunctionName(functionName)
                    
                    expect(genericPlaceholders.placeholders.count).to(equal(2))
                    expect(genericPlaceholders.placeholders.first?.typeName).to(equal("T"))
                    expect(genericPlaceholders.placeholders.first?.constraints).to(equal([]))
                    expect(genericPlaceholders.placeholders.last?.typeName).to(equal("U"))
                    expect(genericPlaceholders.placeholders.last?.constraints).to(equal(["CollectionType"]))
                    expect(genericPlaceholders.whereClause).to(equal("U.Generator.Element == T"))
                }
            }
        }
    }
}
