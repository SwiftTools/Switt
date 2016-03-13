class SwiftSupport {
    static func isBinaryOp() -> Bool {
        return true
    }
    static func isPrefixOp() -> Bool {
        return true
    }
    static func isPostfixOp() -> Bool {
        return true
    }
    static func checkOperatorHead() -> Bool {
        return true
    }
    
    static func isOperator(string: String) -> ProductionRuleCheckFunction {
        return isBinaryOp
    }
}

class SwiftGrammarLexicalStructure: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.identifier,
            ~.Identifier | ~.context_sensitive_keyword
        )
        
        register(.Identifier,
            ~.Identifier_head ~ ??.Identifier_characters
                | "_" ~ .Identifier_characters
                | "`" ~ (~.Identifier_head | ~"_") ~ ??.Identifier_characters ~ "`"
                | .Implicit_parameter_name
        )
        
        register(.identifier_list,
            .identifier ~ zeroOrMore("," ~ .identifier)
        )
        
        let identifierHeadChars: [ProductionRule] = [
            char("a", "z"),
            char("A", "Z"),
            char(0x00A8),
            char(0x00AA),
            char(0x00AD),
            char(0x00AF),
            char(0x00B2, 0x00B5),
            char(0x00B7, 0x00BA),
            char(0x00BC, 0x00BE),
            char(0x00D8, 0x00F6),
            char(0x00F8, 0x00FF),
            char(0x0370, 0x167F),
            char(0x1681, 0x180D),
            char(0x180F, 0x1DBF),
            char(0x1E00, 0x1FFF),
            char(0x200B, 0x200D),
            char(0x202A, 0x202E),
            char(0x203F, 0x2040),
            char(0x2054),
            char(0x2060, 0x206F),
            char(0x2070, 0x20CF),
            char(0x2100, 0x218F),
            char(0x2460, 0x24FF),
            char(0x2776, 0x2793),
            char(0x2C00, 0x2DFF),
            char(0x2E80, 0x2FFF),
            char(0x3004, 0x3007),
            char(0x3021, 0x302F),
            char(0x3031, 0x303F),
            char(0x3040, 0xD7FF),
            char(0xF900, 0xFD3D),
            char(0xFD40, 0xFDCF),
            char(0xFDF0, 0xFE1F),
            char(0xFE30, 0xFE44),
            char(0xFE30, 0xFE44),
            char(0xFE47, 0xFFFD)
        ]
        
        registerFragment(.Identifier_head,
            any(
                identifierHeadChars
            )
        )
        
        registerFragment(.Identifier_character,
            any(
                char("0", "9"),
                char(0x0300, 0x036F),
                char(0x1DC0, 0x1DFF),
                char(0x20D0, 0x20FF),
                char(0xFE20, 0xFE2F),
                ~.Identifier_head,
                ~"_"
            )
        )
        
        register(.context_sensitive_keyword,
            any(
                "associativity",
                "convenience",
                "dynamic",
                "didSet",
                "fina",
                "get",
                "infix",
                "indirect",
                "lazy",
                "left",
                "mutating",
                "none",
                "nonmutating",
                "optional",
                "operator",
                "override",
                "postfix",
                "precedence",
                "prefix",
                "Protocol",
                "required",
                "right",
                "set",
                "Type",
                "unowned",
                "unowned",
                "weak",
                "willSet"
            )
        )
        
        register(.assignment_operator,
            check(SwiftSupport.isBinaryOp) ~ "="
        )
        
        register(.DOT, char("."))
        register(.LCURLY, char("{"))
        register(.LPAREN, char("("))
        register(.LBRACK, char("["))
        register(.RCURLY, char("}"))
        register(.RPAREN, char(")"))
        register(.RBRACK, char("]"))
        register(.COMMA, char(","))
        register(.COLON, char(":"))
        register(.SEMI, char(";"))
        register(.LT, char("<"))
        register(.GT, char(">"))
        register(.UNDERSCORE, char("_"))
        register(.BANG, char("!"))
        register(.QUESTION, char("?"))
        register(.AT, char("@"))
        register(.AND, char("&"))
        register(.SUB, char("-"))
        register(.EQUAL, char("="))
        register(.OR, char("|"))
        register(.DIV, char("/"))
        register(.ADD, char("+"))
        register(.MUL, char("*"))
        register(.MOD, char("%"))
        register(.CARET, char("^"))
        register(.TILDE, char("~"))
        
        // ANTLR comment:
        // Need to separate this out from Prefix_operator as it's referenced in numeric_literal
        
        register(.negate_prefix_operator,
            check(SwiftSupport.isPrefixOp) ~ "-"
        )
        
        register(.build_AND,
            check(SwiftSupport.isOperator("&&")) ~ "&" ~ "&"
        )
        
        register(.build_OR,
            check(SwiftSupport.isOperator("||")) ~ "|" ~ "|"
        )
        
        register(.arrow_operator,
            check(SwiftSupport.isOperator("->")) ~ "-" ~ ">"
        )
        
        register(.range_operator,
            check(SwiftSupport.isOperator("...")) ~ "." ~ "." ~ "."
        )
        
        register(.same_type_equals,
            check(SwiftSupport.isOperator("==")) ~ "=" ~ "="
        )
        
        // ANTLR comment:
        /**
        "If an operator has whitespace around both sides or around neither side,
        it is treated as a binary operator. As an example, the + operator in a+b
        and a + b is treated as a binary operator."
        */
        register(.binary_operator,
            check(SwiftSupport.isBinaryOp) ~ ._operator
        )
        
        // ANTLR comment:
        /**
        "If an operator has whitespace on the left side only, it is treated as a
        prefix unary operator. As an example, the ++ operator in a ++b is treated
        as a prefix unary operator."
        */
        register(.prefix_operator,
            check(SwiftSupport.isPrefixOp) ~ ._operator
        )
        
        // ANTLR comment:
        /**
        "If an operator has whitespace on the right side only, it is treated as a
        postfix unary operator. As an example, the ++ operator in a++ b is treated
        as a postfix unary operator."
        "If an operator has no whitespace on the left but is followed immediately
        by a dot (.), it is treated as a postfix unary operator. As an example,
        the ++ operator in a++.b is treated as a postfix unary operator (a++ .b
        rather than a ++ .b)."
        */
        register(.postfix_operator,
            check(SwiftSupport.isPostfixOp) ~ ._operator
        )
        
        register(._operator,
            any(
                .operator_head ~ oneOrMore(
                    check(SwiftSupport.checkOperatorHead) ~ .operator_character
                ),
                .dot_operator_head ~ oneOrMore(
                    check(SwiftSupport.checkOperatorHead) ~ .dot_operator_character
                )
            )
        )
        
        register(.operator_character,
            ~.operator_head | ~.Operator_following_character
        )
        
        register(.operator_head,
            ~"/" | ~"=" | ~"-" | ~"+" | ~"!" | ~"*" | ~"%" | ~"&" | ~"|" | ~"<" | ~">" | ~"^" | ~"~" | ~"?"
            | .Operator_head_other
        )
        
        // ANTLR comment:
        // valid operator chars not used by Swift itself
        let operatorHeadOtherChars: [ProductionRule] = [
            char(0x00A1, 0x00A7),
            char(0x00A9),
            char(0x00AB),
            char(0x00AC),
            char(0x00AE),
            char(0x00B0, 0x00B1) ,
            char(0x00B6),
            char(0x00BB),
            char(0x00BF),
            char(0x00D7),
            char(0x00F7),
            char(0x2016, 0x2017) ,
            char(0x2020, 0x2027),
            char(0x2030, 0x203E),
            char(0x2041, 0x2053),
            char(0x2055, 0x205E),
            char(0x2190, 0x23FF),
            char(0x2500, 0x2775),
            char(0x2794, 0x2BFF),
            char(0x2E00, 0x2E7F),
            char(0x3001, 0x3003),
            char(0x3008, 0x3030)
        ]
        register(.Operator_head_other,
            any(
                operatorHeadOtherChars
            )
        )
        
        register(.Operator_following_character,
            any(
                char(0x0300, 0x036F),
                char(0x1DC0, 0x1DFF),
                char(0x20D0, 0x20FF),
                char(0xFE00, 0xFE0F),
                char(0xFE20, 0xFE2F),
                // ANTLR comment: ANTLR can't do >16bit char
                // Thanks, antlr =)
                char(0xE0100, 0xE01EF)
            )
        )
        
        register(.dot_operator_head, "." ~ ".") // ANTLR comment: TODO: adjacent cols
        register(.dot_operator_character,  ~"." | ~.operator_character)
        
        register(.Implicit_parameter_name, "$" ~ .Pure_decimal_digits)
        
        // GRAMMAR OF A LITERAL
        
        register(.literal,
            any(
                .numeric_literal,
                .string_literal,
                .boolean_literal,
                .nil_literal
            )
        )
        
        register(.numeric_literal,
            any(
                compound(
                    optional(.negate_prefix_operator),
                    required(.integer_literal)
                ),
                compound(
                    optional(.negate_prefix_operator),
                    required(.Floating_point_literal)
                )
            )
        )
        
        register(.boolean_literal, "true" ~ "false")
        register(.nil_literal, ~"nil")
        
        // GRAMMAR OF AN INTEGER LITERAL
        
        register(.integer_literal,
            any(
                .Binary_literal,
                .Octal_literal,
                .Decimal_literal,
                .Pure_decimal_digits,
                .Hexadecimal_literal
            )
        )
        
        // binary
        
        register(.Binary_literal, "0b" ~ .Binary_digit ~ ??.Binary_literal_characters)
        
        registerFragment(.Binary_digit, char("0", "1"))
        registerFragment(.Binary_literal_character, ~.Binary_digit | ~"_")
        registerFragment(.Binary_literal_characters, oneOrMore(.Binary_literal_character))
        
        // octal
        
        register(.Octal_literal, "0o" ~ .Binary_digit ~ ??.Binary_literal_characters)
        
        registerFragment(.Octal_digit, char("0", "7"))
        registerFragment(.Octal_literal_character, ~.Octal_digit | ~"_")
        registerFragment(.Octal_literal_characters, oneOrMore(.Octal_literal_character))
        
        // decimal
        
        register(.Decimal_literal, char("0", "9") ~ zeroOrMore(char("0", "9")))
        register(.Pure_decimal_digits, oneOrMore(char("0", "9")))
        
        registerFragment(.Decimal_digit, char("0", "9"))
        registerFragment(.Decimal_literal_character, ~.Decimal_digit | ~"_")
        registerFragment(.Decimal_literal_characters, oneOrMore(.Decimal_literal_character))

        // hex
        
        register(.Hexadecimal_literal, "0x" ~ .Hexadecimal_digit ~ ??.Hexadecimal_literal_characters)
        
        registerFragment(.Hexadecimal_digit, char("0", "9") | char("a", "f") | char("A", "F"))
        registerFragment(.Hexadecimal_literal_character, ~.Hexadecimal_digit | ~"_")
        registerFragment(.Hexadecimal_literal_characters, oneOrMore(.Hexadecimal_literal_character))
        
        // GRAMMAR OF A FLOATING_POINT LITERAL

        register(.Floating_point_literal,
            any(
                compound(
                    ~.Decimal_literal,
                    ??.Decimal_fraction,
                    ??.Decimal_exponent
                ),
                compound(
                    ~.Hexadecimal_literal,
                    ??.Hexadecimal_fraction,
                    ??.Hexadecimal_exponent
                )
            )
        )
        
        registerFragment(.Decimal_fraction, "." ~ .Decimal_literal)
        registerFragment(.Decimal_exponent, .Floating_point_e ~ ??.Sign ~ .Decimal_literal)
        
        registerFragment(.Hexadecimal_fraction, "." ~ .Hexadecimal_digit ~ ??.Hexadecimal_literal_characters)
        registerFragment(.Hexadecimal_exponent, .Floating_point_p ~ ??.Sign ~ .Decimal_literal)
        
        registerFragment(.Floating_point_e, "e" ~ "E")
        registerFragment(.Floating_point_p, "p" ~ "P")
        
        registerFragment(.Sign, "+" ~ "\\" ~ "-")
        
        // GRAMMAR OF A STRING LITERAL
        
        register(.string_literal, .Static_string_literal ~ .Interpolated_string_literal)
        register(.Static_string_literal, "\"" ~ "\"")
        
        register(.Quoted_text, oneOrMore(.Quoted_text_item))
        register(.Quoted_text_item, notChar(["\"", "\n", "\r", "\\"]))
        
        registerFragment(.Escaped_character,
            any(
                "\\" ~ char(["0", "\\", "t", "n", "r", "\""]),
                "\\x" ~ .Hexadecimal_digit ~ .Hexadecimal_digit,
                "\\u" ~ "{" ~ times(4, .Hexadecimal_digit) ~ "}",
                "\\u" ~ "{" ~ times(8, .Hexadecimal_digit) ~ "}"
            )
        )
        
        register(.Interpolated_string_literal,
            "\"" ~ zeroOrMore(.Interpolated_text_item) ~ "\""
        )
        
        registerFragment(.Interpolated_text_item,
            any(
                "\\(" ~ oneOrMore(~.Interpolated_string_literal | ~.Interpolated_text_item) ~ ")", // nested strings allowed
                ~.Quoted_text_item
            )
        )
        
        // TODO: -> channel(HIDDEN)
        register(.WS,
            oneOrMore(char([" ", "\n", "\r", "\t", "\u{000B}", "\u{000C}", "\u{0000}"]))
        )
        
        // TODO: -> channel(HIDDEN)
        register(.Block_comment,
            "/*" ~ lazy(.Block_comment ~ anyChar()) ~ "*/"
        )
        
        // TODO: -> channel(HIDDEN)
        register(.Line_comment,
            "//" ~ lazy(anyChar()) ~ any(~"\n", eof())
        )
    }
}