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
            guard let child = declaration.children?.first else {
                continue
            }
            
            if let importDeclaration = child as? SwiftParser.Import_declarationContext {
                scannedContext.importDeclarations.append(importDeclaration)
                
            } else if let constantDeclaration = child as? SwiftParser.Constant_declarationContext {
                scannedContext.constantDeclarations.append(constantDeclaration)
                
            } else if let variableDeclaration = child as? SwiftParser.Variable_declarationContext {
                scannedContext.variableDeclarations.append(variableDeclaration)
                
            } else if let typealiasDeclaration = child as? SwiftParser.Typealias_declarationContext {
                scannedContext.typealiasDeclarations.append(typealiasDeclaration)
                
            } else if let functionDeclaration = child as? SwiftParser.Function_declarationContext {
                scannedContext.functionDeclarations.append(functionDeclaration)
                
            } else if let enumDeclaration = child as? SwiftParser.Enum_declarationContext {
                scannedContext.enumDeclarations.append(enumDeclaration)
                
            } else if let structDeclaration = child as? SwiftParser.Struct_declarationContext {
                scannedContext.structDeclarations.append(structDeclaration)
                
            } else if let classDeclaration = child as? SwiftParser.Class_declarationContext {
                scannedContext.classDeclarations.append(classDeclaration)
                
            } else if let protocolDeclaration = child as? SwiftParser.Protocol_declarationContext {
                scannedContext.protocolDeclarations.append(protocolDeclaration)
                
            } else if let initializerDeclaration = child as? SwiftParser.Initializer_declarationContext {
                scannedContext.initializerDeclarations.append(initializerDeclaration)
                
            } else if let deinitializerDeclaration = child as? SwiftParser.Deinitializer_declarationContext {
                scannedContext.deinitializerDeclarations.append(deinitializerDeclaration)
                
            } else if let extensionDeclaration = child as? SwiftParser.Extension_declarationContext {
                scannedContext.extensionDeclarations.append(extensionDeclaration)
                
            } else if let subscriptDeclaration = child as? SwiftParser.Subscript_declarationContext {
                scannedContext.subscriptDeclarations.append(subscriptDeclaration)
                
            } else if let operatorDeclaration = child as? SwiftParser.Operator_declarationContext {
                scannedContext.operatorDeclarations.append(operatorDeclaration)
            }
        }
        
        return scannedContext
    }
}