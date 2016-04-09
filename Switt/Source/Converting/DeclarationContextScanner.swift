import SwiftGrammar

struct ScannedDeclarationContexts {
    // var ([a-z]+?)([A-Z][a-z]*?)s: \[([a-zA-Z_.]*?)\] = \[\]
    // } else if let $1$2 = declaration.$1_\l$2() {\n    scannedContext.$1$2s.append($1$2)\n
    
    var importDeclarations: [SwiftParser.Import_declarationContext] = []
    var constantDeclarations: [SwiftParser.Constant_declarationContext] = []
    var variableDeclarations: [SwiftParser.Variable_declarationContext] = []
    var typealiasDeclarations: [SwiftParser.Typealias_declarationContext] = []
    var functionDeclarations: [SwiftParser.Function_declarationContext] = []
    var enumDeclarations: [SwiftParser.Enum_declarationContext] = []
    var structDeclarations: [SwiftParser.Struct_declarationContext] = []
    var classDeclarations: [SwiftParser.Class_declarationContext] = []
    var protocolDeclarations: [SwiftParser.Protocol_declarationContext] = []
    var initializerDeclarations: [SwiftParser.Initializer_declarationContext] = []
    var deinitializerDeclarations: [SwiftParser.Deinitializer_declarationContext] = []
    var extensionDeclarations: [SwiftParser.Extension_declarationContext] = []
    var subscriptDeclarations: [SwiftParser.Subscript_declarationContext] = []
    var operatorDeclarations: [SwiftParser.Operator_declarationContext] = []
}

final class DeclarationContextsScanner {
    func scan(context: SwiftParser.DeclarationsContext) -> ScannedDeclarationContexts {
        return scan(context.declaration())
    }
    
    func scan(declarationContexts: [SwiftParser.DeclarationContext]) -> ScannedDeclarationContexts {
        var scannedContext = ScannedDeclarationContexts()
        
        for declaration in declarationContexts {
            if let importDeclaration = declaration.import_declaration() {
                scannedContext.importDeclarations.append(importDeclaration)
                
            } else if let constantDeclaration = declaration.constant_declaration() {
                scannedContext.constantDeclarations.append(constantDeclaration)
                
            } else if let variableDeclaration = declaration.variable_declaration() {
                scannedContext.variableDeclarations.append(variableDeclaration)
                
            } else if let typealiasDeclaration = declaration.typealias_declaration() {
                scannedContext.typealiasDeclarations.append(typealiasDeclaration)
                
            } else if let functionDeclaration = declaration.function_declaration() {
                scannedContext.functionDeclarations.append(functionDeclaration)
                
            } else if let enumDeclaration = declaration.enum_declaration() {
                scannedContext.enumDeclarations.append(enumDeclaration)
                
            } else if let structDeclaration = declaration.struct_declaration() {
                scannedContext.structDeclarations.append(structDeclaration)
                
            } else if let classDeclaration = declaration.class_declaration() {
                scannedContext.classDeclarations.append(classDeclaration)
                
            } else if let protocolDeclaration = declaration.protocol_declaration() {
                scannedContext.protocolDeclarations.append(protocolDeclaration)
                
            } else if let initializerDeclaration = declaration.initializer_declaration() {
                scannedContext.initializerDeclarations.append(initializerDeclaration)
                
            } else if let deinitializerDeclaration = declaration.deinitializer_declaration() {
                scannedContext.deinitializerDeclarations.append(deinitializerDeclaration)
                
            } else if let extensionDeclaration = declaration.extension_declaration() {
                scannedContext.extensionDeclarations.append(extensionDeclaration)
                
            } else if let subscriptDeclaration = declaration.subscript_declaration() {
                scannedContext.subscriptDeclarations.append(subscriptDeclaration)
                
            } else if let operatorDeclaration = declaration.operator_declaration() {
                scannedContext.operatorDeclarations.append(operatorDeclaration)
            }
        }
        
        return scannedContext
    }
}