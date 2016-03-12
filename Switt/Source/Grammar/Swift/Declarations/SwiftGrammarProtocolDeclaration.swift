class SwiftGrammarProtocolDeclaration: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.protocol_declaration,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("protocol"),
                required(.protocol_name),
                optional(.type_inheritance_clause),
                required(.protocol_body)
            )
        )
        register(.protocol_name,
            required(.identifier)
        )
        register(.protocol_body,
            compound(
                required("{"),
                optional(.protocol_member_declarations),
                required("}")
                
            )
        )
        register(.protocol_member_declaration,
            any(
                .protocol_property_declaration,
                .protocol_method_declaration,
                .protocol_initializer_declaration,
                .protocol_subscript_declaration,
                .protocol_associated_type_declaration
            )
        )
        
        register(.protocol_member_declarations,
            compound(
                required(.protocol_member_declaration),
                optional(.protocol_member_declarations)
                
            )
        )
        
        register(.protocol_property_declaration,
            compound(
                .variable_declaration_head,
                .variable_name,
                .type_annotation,
                .getter_setter_keyword_block
            )
        )
        
        register(.protocol_method_declaration,
            compound(
                required(.function_head),
                required(.function_name),
                optional(.generic_parameter_clause),
                required(.function_signature)
            )
        )
        
        register(.protocol_initializer_declaration,
            any(
                compound(
                    required(.initializer_head),
                    optional(.generic_parameter_clause),
                    required(.parameter_clause),
                    optional("throws")
                ),
                compound(
                    required(.initializer_head),
                    optional(.generic_parameter_clause),
                    required(.parameter_clause),
                    required("rethrows")
                )
            )
        )
        
        register(.protocol_subscript_declaration,
            compound(
                required(.subscript_head),
                required(.subscript_result),
                required(.getter_setter_keyword_block)
            )
        )
        
        register(.protocol_associated_type_declaration,
            compound(
                required(.typealias_head),
                optional(.type_inheritance_clause),
                optional(.typealias_assignment)
                
            )
        )
    }
}