//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

class UnexpectedDeclarationsLogger {
    private let logger: SourceKitStructureScanningLogger
    
    init(logger: SourceKitStructureScanningLogger) {
        self.logger = logger
    }
    
    func logUnexpectedDeclarations(declarations: SortedSubDeclarations, declarationsExpectance: DeclarationExpectance) {
        if !declarationsExpectance.inits {
            for declaration in declarations.inits {
                logger.logUnexpectedDeclaration(Declaration.FunctionConstructor(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.deinits {
            for declaration in declarations.deinits {
                logger.logUnexpectedDeclaration(Declaration.FunctionDestructor(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.instanceMethods {
            for declaration in declarations.instanceMethods {
                logger.logUnexpectedDeclaration(Declaration.FunctionMethodInstance(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.classMethods {
            for declaration in declarations.classMethods {
                logger.logUnexpectedDeclaration(Declaration.FunctionMethodClass(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.staticMethods {
            for declaration in declarations.staticMethods {
                logger.logUnexpectedDeclaration(Declaration.FunctionMethodStatic(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.classes {
            for declaration in declarations.classes {
                logger.logUnexpectedDeclaration(Declaration.Class(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.structs {
            for declaration in declarations.structs {
                logger.logUnexpectedDeclaration(Declaration.Struct(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.typealiases {
            for declaration in declarations.typealiases {
                logger.logUnexpectedDeclaration(Declaration.Typealias(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.staticVars {
            for declaration in declarations.staticVars {
                logger.logUnexpectedDeclaration(Declaration.VarStatic(declaration), inScanner: self)
            }
        }
        if !declarationsExpectance.instanceVars {
            for declaration in declarations.instanceVars {
                logger.logUnexpectedDeclaration(Declaration.VarInstance(declaration), inScanner: self)
            }
        }
    }
}