//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

public class SourceKitStructureScanner {
    private let dependencies: SourceKitStructureScanningDependencies
    
    public init(dependencies: SourceKitStructureScanningDependencies) {
        self.dependencies = dependencies
    }
    
    public func scanDeclarations() -> [Declaration] {
        var declarations: [Declaration] = []
        
        if let kind = dependencies.sourceKitStructure.kind {
            switch kind {
            case .decl_class:
                if let declaration = SourceKitStructureClassScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Class(declaration))
                }
                
            case .decl_enum:
                if let declaration = SourceKitStructureEnumScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Enum(declaration))
                }
                
            case .decl_enumcase:
                if let declaration = SourceKitStructureEnumcaseScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Enumcase(declaration))
                }
                
            case .decl_enumelement:
                if let declaration = SourceKitStructureEnumelementScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Enumelement(declaration))
                }
                
            case .decl_extension:
                if let declaration = SourceKitStructureExtensionScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Extension(declaration))
                }
                
            case .decl_extension_class:
                if let declaration = SourceKitStructureExtensionClassScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.ExtensionClass(declaration))
                }
                
            case .decl_extension_enum:
                if let declaration = SourceKitStructureExtensionEnumScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.ExtensionEnum(declaration))
                }
                
            case .decl_extension_protocol:
                if let declaration = SourceKitStructureExtensionProtocolScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.ExtensionProtocol(declaration))
                }
                
            case .decl_extension_struct:
                if let declaration = SourceKitStructureExtensionStructScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.ExtensionStruct(declaration))
                }
                
            case .decl_function_accessor_address:
                if let declaration = SourceKitStructureFunctionAccessorAddressScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionAccessorAddress(declaration))
                }
                
            case .decl_function_accessor_didset:
                if let declaration = SourceKitStructureFunctionAccessorDidsetScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionAccessorDidset(declaration))
                }
                
            case .decl_function_accessor_getter:
                if let declaration = SourceKitStructureFunctionAccessorGetterScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionAccessorGetter(declaration))
                }
                
            case .decl_function_accessor_mutableaddress:
                if let declaration = SourceKitStructureFunctionAccessorMutableaddressScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionAccessorMutableaddress(declaration))
                }
                
            case .decl_function_accessor_setter:
                if let declaration = SourceKitStructureFunctionAccessorSetterScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionAccessorSetter(declaration))
                }
                
            case .decl_function_accessor_willset:
                if let declaration = SourceKitStructureFunctionAccessorWillsetScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionAccessorWillset(declaration))
                }
                
            case .decl_function_constructor:
                if let declaration = SourceKitStructureFunctionConstructorScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionConstructor(declaration))
                }
                
            case .decl_function_destructor:
                if let declaration = SourceKitStructureFunctionDestructorScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionDestructor(declaration))
                }
                
            case .decl_function_free:
                if let declaration = SourceKitStructureFunctionFreeScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionFree(declaration))
                }
                
            case .decl_function_method_class:
                if let declaration = SourceKitStructureFunctionMethodClassScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionMethodClass(declaration))
                }
                
            case .decl_function_method_instance:
                if let declaration = SourceKitStructureFunctionMethodInstanceScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionMethodInstance(declaration))
                }
                
            case .decl_function_method_static:
                if let declaration = SourceKitStructureFunctionMethodStaticScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionMethodStatic(declaration))
                }
                
            case .decl_function_operator:
                if let declaration = SourceKitStructureFunctionOperatorScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionOperator(declaration))
                }
                
            case .decl_function_subscript:
                if let declaration = SourceKitStructureFunctionSubscriptScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.FunctionSubscript(declaration))
                }
                
            case .decl_generic_type_param:
                if let declaration = SourceKitStructureGenericTypeParamScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.GenericTypeParam(declaration))
                }
                
            case .decl_module:
                if let declaration = SourceKitStructureModuleScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Module(declaration))
                }
                
            case .decl_protocol:
                if let declaration = SourceKitStructureProtocolScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Protocol(declaration))
                }
                
            case .decl_struct:
                if let declaration = SourceKitStructureStructScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Struct(declaration))
                }
                
            case .decl_typealias:
                if let declaration = SourceKitStructureTypealiasScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.Typealias(declaration))
                }
                
            case .decl_var_class:
                if let declaration = SourceKitStructureVarClassScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.VarClass(declaration))
                }
                
            case .decl_var_global:
                if let declaration = SourceKitStructureVarGlobalScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.VarGlobal(declaration))
                }
                
            case .decl_var_instance:
                if let declaration = SourceKitStructureVarInstanceScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.VarInstance(declaration))
                }
                
            case .decl_var_local:
                if let declaration = SourceKitStructureVarLocalScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.VarLocal(declaration))
                }
                
            case .decl_var_parameter:
                if let declaration = SourceKitStructureVarParameterScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.VarParameter(declaration))
                }
                
            case .decl_var_static:
                if let declaration = SourceKitStructureVarStaticScanner(dependencies: dependencies).scanDeclaration() {
                    declarations.append(.VarStatic(declaration))
                }
            case .expr_array:
                break
            case .expr_call:
                break
            case .structure_elem_expr:
                break
            case .structure_elem_typeref:
                break
            }
        }
        
        return declarations
    }
}