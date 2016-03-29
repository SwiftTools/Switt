class SwiftGrammarProtocolDeclaration: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.protocol_declaration,
            compound(
                optional(.attributes),
                optional(.access_level_modifier),
                required("protocol"),
                required(.protocol_name),
                optional(.type_inheritance_clause),
                required(.protocol_body)
            )
        )
        parserRule(.protocol_name,
            required(.identifier)
        )
        parserRule(.protocol_body,
            compound(
                required("{"),
                optional(.protocol_member_declarations),
                required("}")
                
            )
        )
        parserRule(.protocol_member_declaration,
            any(
                .protocol_property_declaration,
                .protocol_method_declaration,
                .protocol_initializer_declaration,
                .protocol_subscript_declaration,
                .protocol_associated_type_declaration
            )
        )
        
        parserRule(.protocol_member_declarations,
            compound(
                required(.protocol_member_declaration),
                optional(.protocol_member_declarations)
                
            )
        )
        
        parserRule(.protocol_property_declaration,
            compound(
                .variable_declaration_head,
                .variable_name,
                .type_annotation,
                .getter_setter_keyword_block
            )
        )
        
        parserRule(.protocol_method_declaration,
            compound(
                required(.function_head),
                required(.function_name),
                optional(.generic_parameter_clause),
                required(.function_signature)
            )
        )
        
        parserRule(.protocol_initializer_declaration,
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
        
        parserRule(.protocol_subscript_declaration,
            compound(
                required(.subscript_head),
                required(.subscript_result),
                required(.getter_setter_keyword_block)
            )
        )
        
        parserRule(.protocol_associated_type_declaration,
            compound(
                required(.typealias_head),
                optional(.type_inheritance_clause),
                optional(.typealias_assignment)
                
            )
        )
    }
}