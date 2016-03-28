class SwiftGrammarTypes: GrammarRulesRegistrator {
    var grammarRegistry: GrammarRegistry = GrammarRegistry()
    
    func registerRules() {
        clearRules()
        
        parserRule(.type,
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
        
        parserRule(.type_annotation,
            ":" ~ ??.attributes ~ .type
        )
        
        // .GRAMMAR OF .A TYPE .IDENTIFIER
        
        parserRule(.type_identifier,
            .type_name ~ ??.generic_argument_clause
                | .type_name ~ ??.generic_argument_clause ~ "." ~ .type_identifier
        )
        parserRule(.type_name,
            ~.identifier
        )
        
        // .GRAMMAR OF .A TUPLE .TYPE
        
        parserRule(.tuple_type,
            "(" ~ ??.tuple_type_body ~ ")"
        )
        parserRule(.tuple_type_body,
            .tuple_type_element_list ~ ??.range_operator
        )
        parserRule(.tuple_type_element_list,
            .tuple_type_element | .tuple_type_element ~ "," ~ .tuple_type_element_list
        )
        parserRule(.tuple_type_element,
            ??.attributes ~ ??"inout" ~ .type | ??"inout" ~ .element_name ~ .type_annotation
        )
        parserRule(.element_name,
            ~.identifier
        )
        
        // .GRAMMAR OF .A PROTOCOL .COMPOSITION .TYPE
        
        parserRule(.protocol_composition_type,
            "protocol" ~ "<" ~ ??.protocol_identifier_list ~ ">"
        )
        
        parserRule(.protocol_identifier_list,
            .protocol_identifier | zeroOrMore("," ~ .protocol_identifier)
        )
        
        parserRule(.protocol_identifier,
            ~.type_identifier
        )
        
        // inheritance clause
        
        parserRule(.type_inheritance_clause,
            ":" ~ .class_requirement ~ "," ~ .type_inheritance_list
                | ":" ~ .class_requirement
                | ":" ~ .type_inheritance_list
        )
        parserRule(.type_inheritance_list,
            .type_identifier
                | .type_identifier ~ "," ~ .type_inheritance_list
        )
        parserRule(.class_requirement,
            ~"class"
        )
    }
}