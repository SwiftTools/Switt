//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

class SourceKitStructureBaseScanner {
    private let sourceKitStructure: SourceKitStructure
    private let file: SourceKitFile
    private let declarationPath: DeclarationPath
    private let unexpectedDeclarationsLogger: UnexpectedDeclarationsLogger
    
    private let varScanner: VarScanner
    private let functionScanner: FunctionScanner
    private let codeScanner: SourceKitStructureCodeScanner
    private let subDeclarationsSorter: SubDeclarationsSorter
    private let sourceKitAccessibilityConverter = SourceKitAccessibilityConverter()
    private let genericPlaceholdersScanner = GenericPlaceholdersScanner()
    private var lazySubDeclarations: SortedSubDeclarations?
    private var declarationsExpectance = DeclarationExpectance()
    
    init(dependencies: SourceKitStructureScanningDependencies) {
        sourceKitStructure = dependencies.sourceKitStructure
        file = dependencies.file
        declarationPath = dependencies.declarationPath
        
        varScanner = VarScanner(dependencies: dependencies)
        functionScanner = FunctionScanner(dependencies: dependencies)
        unexpectedDeclarationsLogger = UnexpectedDeclarationsLogger(logger: dependencies.logger)
        subDeclarationsSorter = SubDeclarationsSorter(dependencies: dependencies)
        codeScanner = SourceKitStructureCodeScanner(sourceKitStructure: dependencies.sourceKitStructure, file: dependencies.file)
    }
    
    // MARK: - Scanning
    
    func name() throws -> String {
        return try sourceKitStructure.name.unwrap()
    }
    
    func runtimeName() throws -> String {
        return try sourceKitStructure.runtime_name.unwrap()
    }
    
    func accessibility() throws -> Accessibility {
        return sourceKitAccessibilityConverter.accessibility(try sourceKitStructure.accessibility.unwrap())
    }
    
    func functionName() throws -> String {
        return try functionScanner.name().unwrap()
    }
    
    func functionNameAndArguments() throws -> String {
        return try functionScanner.nameAndArguments().unwrap()
    }
    
    func functionReturnType() throws -> String {
        return try functionScanner.returnType().unwrap()
    }
    
    func varType() -> String? {
        return varScanner.type()
    }
    
    func varExpression() -> String? {
        return varScanner.expression()
    }
    
    func varParameterName() -> String? {
        return codeScanner.scanName()
    }
    
    func inits() -> [FunctionConstructorDeclaration] {
        declarationsExpectance.inits = true
        return subDeclarations().inits
    }
    
    func deinits() -> [FunctionDestructorDeclaration] {
        declarationsExpectance.deinits = true
        return subDeclarations().deinits
    }
    
    func instanceMethods() -> [FunctionMethodInstanceDeclaration] {
        declarationsExpectance.instanceMethods = true
        return subDeclarations().instanceMethods
    }
    
    func classMethods() -> [FunctionMethodClassDeclaration] {
        declarationsExpectance.classMethods = true
        return subDeclarations().classMethods
    }
    
    func staticMethods() -> [FunctionMethodStaticDeclaration] {
        declarationsExpectance.staticMethods = true
        return subDeclarations().staticMethods
    }
    
    func classes() -> [ClassDeclaration] {
        declarationsExpectance.classes = true
        return subDeclarations().classes
    }
    
    func structs() -> [StructDeclaration] {
        declarationsExpectance.structs = true
        return subDeclarations().structs
    }
    
    func typealiases() -> [TypealiasDeclaration] {
        declarationsExpectance.typealiases = true
        return subDeclarations().typealiases
    }
    
    func staticVars() -> [VarStaticDeclaration] {
        declarationsExpectance.staticVars = true
        return subDeclarations().staticVars
    }
    
    func instanceVars() -> [VarInstanceDeclaration] {
        declarationsExpectance.instanceVars = true
        return subDeclarations().instanceVars
    }
    
    func parameters() -> [VarParameterDeclaration] {
        declarationsExpectance.parameters = true
        return subDeclarations().parameters
    }
    
    func genericPlaceholders() -> GenericPlaceholders {
        if let functionName = codeScanner.scanName() {
            return genericPlaceholdersScanner.scanGenericPlaceholdersInFunctionName(functionName)
        } else {
            // TODO: error and better result
            return GenericPlaceholders(placeholders: [], whereClause: nil)
        }
    }
    
    // MARK: - Services
    
    func resetExpectations() {
        declarationsExpectance = DeclarationExpectance()
    }
    
    func logUnexpectedDeclarations() {
        unexpectedDeclarationsLogger.logUnexpectedDeclarations(subDeclarations(), declarationsExpectance: declarationsExpectance)
    }
    
    // MARK: - Private
    
    private func subDeclarations() -> SortedSubDeclarations {
        if let lazySubDeclarations = lazySubDeclarations {
            return lazySubDeclarations
        } else {
            let subDeclarations = subDeclarationsSorter.sortedSubDeclarations(inScanner: self)
            lazySubDeclarations = subDeclarations
            return subDeclarations
        }
    }
}