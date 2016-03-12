class SwiftGrammarTypes: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        register(.type,
            "[" ~ .type ~ "]"
                | "[" ~ .type ~ ":" ~ .type ~ "]"
                | .type ~ ??"throws" ~ .arrow_operator ~ .type
                | .type ~ "rethrows" ~ .arrow_operator ~ .type
                | .type_identifier
                | .tuple_type
                | .type ~ "?"
                | .type ~ "!"
                | .protocol_composition_type
                | .type ~ "." ~ "Type"
                | .type ~ "." ~ "Protocol"
        )
        
        register(.type_annotation,
            ":" ~ ??.attributes ~ .type
        )
        
        // .GRAMMAR OF .A TYPE .IDENTIFIER
        
        register(.type_identifier,
            .type_name ~ ??.generic_argument_clause
                | .type_name ~ ??.generic_argument_clause ~ "." ~ .type_identifier
        )
        register(.type_name,
            ~.identifier
        )
        
        // .GRAMMAR OF .A TUPLE .TYPE
        
        register(.tuple_type,
            "(" ~ ??.tuple_type_body ~ ")"
        )
        register(.tuple_type_body,
            .tuple_type_element_list ~ ??.range_operator
        )
        register(.tuple_type_element_list,
            .tuple_type_element | .tuple_type_element ~ "," ~ .tuple_type_element_list
        )
        register(.tuple_type_element,
            ??.attributes ~ ??"inout" ~ .type | ??"inout" ~ .element_name ~ .type_annotation
        )
        register(.element_name,
            ~.identifier
        )
        
        // .GRAMMAR OF .A PROTOCOL .COMPOSITION .TYPE
        
        register(.protocol_composition_type,
            "protocol" ~ "<" ~ ??.protocol_identifier_list ~ ">"
        )
        
        register(.protocol_identifier_list,
            .protocol_identifier | zeroOrMore("," ~ .protocol_identifier)
        )
        
        register(.protocol_identifier,
            ~.type_identifier
        )
        
        // inheritance clause
        
        register(.type_inheritance_clause,
            ":" ~ .class_requirement ~ "," ~ .type_inheritance_list
                | ":" ~ .class_requirement
                | ":" ~ .type_inheritance_list
        )
        register(.type_inheritance_list,
            .type_identifier
                | .type_identifier ~ "," ~ .type_inheritance_list
        )
        register(.class_requirement,
            ~"class"
        )
    }
}