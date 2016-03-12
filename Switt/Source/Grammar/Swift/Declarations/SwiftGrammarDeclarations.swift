class SwiftGrammarDeclarations: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
        append(SwiftGrammarVariableDeclaration())
        append(SwiftGrammarTypealiasDeclaration())
        append(SwiftGrammarFunctionDeclaration())
        append(SwiftGrammarEnumDeclaration())
        append(SwiftGrammarStructDeclaration())
        append(SwiftGrammarClassDeclaration())
        append(SwiftGrammarProtocolDeclaration())
        
        // declaration
        
        register(.declaration,
            compound(
                .import_declaration,
                .constant_declaration,
                .variable_declaration,
                .typealias_declaration,
                .function_declaration,
                .enum_declaration,
                .struct_declaration,
                .class_declaration,
                .protocol_declaration,
                .initializer_declaration,
                .deinitializer_declaration,
                .extension_declaration,
                .subscript_declaration,
                .operator_declaration
            )
        )
        
        register(.declarations,
            oneOrMore(
                .declaration
            )
        )
        
        // top-level declaration
        
        register(.top_level_declaration,
            optional(.statements)
        )
        
        // code block
        
        register(.code_block,
            compound(
                required("{"),
                optional(.statements),
                required("}")
                
            )
        )
        
        // import
        
        register(.import_declaration,
            compound(
                optional(.attributes),
                required("import"),
                optional(.import_kind),
                required(.import_path)
            )
        )
        
        register(.import_kind,
            any(
                "typealias",
                "struct",
                "class",
                "enum",
                "protocol",
                "var",
                "func"
            )
        )
        
        register(.import_path,
            any(
                required(.import_path_identifier),
                compound(
                    required(.import_path_identifier),
                    required("."),
                    required(.import_path)
                )
            )
        )
        
        register(.import_path_identifier,
            any(
                .identifier,
                ._operator
            )
        )

        // constant
        
        register(.constant_declaration,
            compound(
                optional(.attributes),
                optional(.declaration_modifiers),
                required("let"),
                required(.pattern_initializer_list)
            )
        )
        
        //
        
        register(.pattern_initializer_list,
            compound(
                required(.pattern_initializer),
                zeroOrMore(
                    required(","),
                    required(.pattern_initializer)
                )
            )
        )
        
        /** rule is ambiguous. can match "var x = 1" with x as pattern
        *  OR with x as expression_pattern.
        *  ANTLR resolves in favor or first choice: pattern is x, 1 is initializer.
        */
        register(.pattern_initializer,
            compound(
                required(.pattern),
                optional(.initializer)
                
            )
        )
        register(.initializer,
            compound(
                .assignment_operator,
                .expression
            )
        )
        
        // declaration modifier
        
        // "expression was too complex to be solved in reasonable time",
        // so I've extracted it to an array
        let declarationModifierLexemes: [Lexeme] = [
            required("class"),
            required("convenience"),
            required("dynamic"),
            required("final"),
            required("infix"),
            required("lazy"),
            required("mutating"),
            required("nonmutating"),
            required("optional"),
            required("override"),
            required("postfix"),
            required("prefix"),
            required("required"),
            required("static"),
            required("unowned"),
            compound(
                required("unowned"),
                required("("),
                required("safe"),
                required(")")
            ),
            compound(
                required("unowned"),
                required("("),
                required("unsafe"),
                required(")")
            ),
            required("weak"),
            required(.access_level_modifier)
        ]
        
        register(.declaration_modifier,
            any(
                declarationModifierLexemes
            )
        )
        
        register(.declaration_modifiers,
            compound(
                required(.declaration_modifier),
                optional(.declaration_modifiers)
            )
        )
        
        let accessLevelModifierLexemes: [Lexeme] = [
            required("internal"),
            compound(
                required("internal"),
                required("("),
                required("set"),
                required(")")
            ),
            required("private"),
            compound(
                required("private"),
                required("("),
                required("set"),
                required(")")
            ),
            required("public"),
            compound(
                required("public"),
                required("("),
                required("set"),
                required(")")
            )
        ]
        register(.access_level_modifier,
            any(
                accessLevelModifierLexemes
            )
        )
    }
}