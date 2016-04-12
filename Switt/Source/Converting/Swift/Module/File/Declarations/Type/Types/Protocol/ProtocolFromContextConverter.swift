import SwiftGrammar

protocol ProtocolFromContextConverter {
    func convert(context: SwiftParser.Protocol_declarationContext?) -> Protocol?
}

class ProtocolFromContextConverterImpl: ProtocolFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Protocol_declarationContext?) -> Protocol? {
        if let context = context {
            guard let name = context.protocol_name()?.getText() else {
                return nil
            }
            
            guard let accessibility = assembly.converter().convert(context.access_level_modifier()) else {
                return nil
            }
            
            var inits = [ProtocolInit]()
            var funcs = [ProtocolFunc]()
            var associatedTypes = [AssociatedType]()
            var vars = [ProtocolVar]()
            var subscripts = [ProtocolSubscript]()
            
            let declarationContexts = GrammarMath.unroll(
                context: context.protocol_body()?.protocol_member_declarations(),
                element: { $0.protocol_member_declaration() },
                list: { $0.protocol_member_declarations() }
            )
            
            if let declarationContexts = declarationContexts {
                for declarationContext in declarationContexts {
                    if let context = declarationContext.protocol_associated_type_declaration() {
                        assembly.converter().convert(context).forEach {
                            associatedTypes.append($0)
                        }
                    } else if let context = declarationContext.protocol_initializer_declaration() {
                        assembly.converter().convert(context).forEach {
                            inits.append($0)
                        }
                    } else if let context = declarationContext.protocol_method_declaration() {
                        assembly.converter().convert(context).forEach {
                            funcs.append($0)
                        }
                    } else if let context = declarationContext.protocol_property_declaration() {
                        assembly.converter().convert(context).forEach {
                            vars.append($0)
                        }
                    } else if let context = declarationContext.protocol_subscript_declaration() {
                        assembly.converter().convert(context).forEach {
                            subscripts.append($0)
                        }
                    }
                }
            }
            
            return ProtocolData(
                name: name,
                accessibility: accessibility,
                inits: inits,
                funcs: funcs,
                associatedTypes: associatedTypes,
                vars: vars,
                subscripts: subscripts
            )
        } else {
            return nil
        }
    }
}