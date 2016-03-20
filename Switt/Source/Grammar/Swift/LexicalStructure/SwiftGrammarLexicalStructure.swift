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

class SwiftGrammarLexicalStructure: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.identifier,
            ~.Identifier | ~.context_sensitive_keyword
        )
        
        lexerRule(.Identifier,
            ~.Identifier_head ~ ??.Identifier_characters
                | "_" ~ .Identifier_characters
                | "`" ~ (~.Identifier_head | ~"_") ~ ??.Identifier_characters ~ "`"
                | .Implicit_parameter_name
        )
        
        parserRule(.identifier_list,
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
        
        lexerFragment(.Identifier_head,
            any(
                identifierHeadChars
            )
        )
        
        lexerFragment(.Identifier_character,
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
        
        lexerFragment(.Identifier_characters,
            oneOrMore(.Identifier_character)
        )
        
        parserRule(.context_sensitive_keyword,
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
        
        parserRule(.assignment_operator,
            check(SwiftSupport.isBinaryOp) ~ "="
        )
        
        lexerRule(.DOT, char("."))
        lexerRule(.LCURLY, char("{"))
        lexerRule(.LPAREN, char("("))
        lexerRule(.LBRACK, char("["))
        lexerRule(.RCURLY, char("}"))
        lexerRule(.RPAREN, char(")"))
        lexerRule(.RBRACK, char("]"))
        lexerRule(.COMMA, char(","))
        lexerRule(.COLON, char(":"))
        lexerRule(.SEMI, char(";"))
        lexerRule(.LT, char("<"))
        lexerRule(.GT, char(">"))
        lexerRule(.UNDERSCORE, char("_"))
        lexerRule(.BANG, char("!"))
        lexerRule(.QUESTION, char("?"))
        lexerRule(.AT, char("@"))
        lexerRule(.AND, char("&"))
        lexerRule(.SUB, char("-"))
        lexerRule(.EQUAL, char("="))
        lexerRule(.OR, char("|"))
        lexerRule(.DIV, char("/"))
        lexerRule(.ADD, char("+"))
        lexerRule(.MUL, char("*"))
        lexerRule(.MOD, char("%"))
        lexerRule(.CARET, char("^"))
        lexerRule(.TILDE, char("~"))
        
        // ANTLR comment:
        // Need to separate this out from Prefix_operator as it's referenced in numeric_literal
        
        parserRule(.negate_prefix_operator,
            check(SwiftSupport.isPrefixOp) ~ "-"
        )
        
        parserRule(.build_AND,
            check(SwiftSupport.isOperator("&&")) ~ "&" ~ "&"
        )
        
        parserRule(.build_OR,
            check(SwiftSupport.isOperator("||")) ~ "|" ~ "|"
        )
        
        parserRule(.arrow_operator,
            check(SwiftSupport.isOperator("->")) ~ "-" ~ ">"
        )
        
        parserRule(.range_operator,
            check(SwiftSupport.isOperator("...")) ~ "." ~ "." ~ "."
        )
        
        parserRule(.same_type_equals,
            check(SwiftSupport.isOperator("==")) ~ "=" ~ "="
        )
        
        // ANTLR comment:
        /**
        "If an operator has whitespace around both sides or around neither side,
        it is treated as a binary operator. As an example, the + operator in a+b
        and a + b is treated as a binary operator."
        */
        parserRule(.binary_operator,
            check(SwiftSupport.isBinaryOp) ~ ._operator
        )
        
        // ANTLR comment:
        /**
        "If an operator has whitespace on the left side only, it is treated as a
        prefix unary operator. As an example, the ++ operator in a ++b is treated
        as a prefix unary operator."
        */
        parserRule(.prefix_operator,
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
        parserRule(.postfix_operator,
            check(SwiftSupport.isPostfixOp) ~ ._operator
        )
        
        parserRule(._operator,
            any(
                .operator_head ~ oneOrMore(
                    check(SwiftSupport.checkOperatorHead) ~ .operator_character
                ),
                .dot_operator_head ~ oneOrMore(
                    check(SwiftSupport.checkOperatorHead) ~ .dot_operator_character
                )
            )
        )
        
        parserRule(.operator_character,
            ~.operator_head | ~.Operator_following_character
        )
        
        parserRule(.operator_head,
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
        lexerRule(.Operator_head_other,
            any(
                operatorHeadOtherChars
            )
        )
        
        lexerRule(.Operator_following_character,
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
        
        parserRule(.dot_operator_head, "." ~ ".") // ANTLR comment: TODO: adjacent cols
        parserRule(.dot_operator_character,  ~"." | ~.operator_character)
        
        lexerRule(.Implicit_parameter_name, "$" ~ .Pure_decimal_digits)
        
        // GRAMMAR OF A LITERAL
        
        parserRule(.literal,
            any(
                .numeric_literal,
                .string_literal,
                .boolean_literal,
                .nil_literal
            )
        )
        
        parserRule(.numeric_literal,
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
        
        parserRule(.boolean_literal, ~"true" | ~"false")
        parserRule(.nil_literal, ~"nil")
        
        // GRAMMAR OF AN INTEGER LITERAL
        
        parserRule(.integer_literal,
            any(
                .Binary_literal,
                .Octal_literal,
                .Decimal_literal,
                .Pure_decimal_digits,
                .Hexadecimal_literal
            )
        )
        
        // binary
        
        lexerRule(.Binary_literal, "0b" ~ .Binary_digit ~ ??.Binary_literal_characters)
        
        lexerFragment(.Binary_digit, char("0", "1"))
        lexerFragment(.Binary_literal_character, ~.Binary_digit | ~"_")
        lexerFragment(.Binary_literal_characters, oneOrMore(.Binary_literal_character))
        
        // octal
        
        lexerRule(.Octal_literal, "0o" ~ .Binary_digit ~ ??.Binary_literal_characters)
        
        lexerFragment(.Octal_digit, char("0", "7"))
        lexerFragment(.Octal_literal_character, ~.Octal_digit | ~"_")
        lexerFragment(.Octal_literal_characters, oneOrMore(.Octal_literal_character))
        
        // decimal
        
        lexerRule(.Decimal_literal, char("0", "9") ~ zeroOrMore(char("0", "9")))
        lexerRule(.Pure_decimal_digits, oneOrMore(char("0", "9")))
        
        lexerFragment(.Decimal_digit, char("0", "9"))
        lexerFragment(.Decimal_literal_character, ~.Decimal_digit | ~"_")
        lexerFragment(.Decimal_literal_characters, oneOrMore(.Decimal_literal_character))

        // hex
        
        lexerRule(.Hexadecimal_literal, "0x" ~ .Hexadecimal_digit ~ ??.Hexadecimal_literal_characters)
        
        lexerFragment(.Hexadecimal_digit, char("0", "9") | char("a", "f") | char("A", "F"))
        lexerFragment(.Hexadecimal_literal_character, ~.Hexadecimal_digit | ~"_")
        lexerFragment(.Hexadecimal_literal_characters, oneOrMore(.Hexadecimal_literal_character))
        
        // GRAMMAR OF A FLOATING_POINT LITERAL

        lexerRule(.Floating_point_literal,
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
        
        lexerFragment(.Decimal_fraction, "." ~ .Decimal_literal)
        lexerFragment(.Decimal_exponent, .Floating_point_e ~ ??.Sign ~ .Decimal_literal)
        
        lexerFragment(.Hexadecimal_fraction, "." ~ .Hexadecimal_digit ~ ??.Hexadecimal_literal_characters)
        lexerFragment(.Hexadecimal_exponent, .Floating_point_p ~ ??.Sign ~ .Decimal_literal)
        
        lexerFragment(.Floating_point_e, "e" ~ "E")
        lexerFragment(.Floating_point_p, "p" ~ "P")
        
        lexerFragment(.Sign, "+" ~ "\\" ~ "-")
        
        // GRAMMAR OF A STRING LITERAL
        
        parserRule(.string_literal, .Static_string_literal ~ .Interpolated_string_literal)
        lexerRule(.Static_string_literal, "\"" ~ "\"")
        
        lexerRule(.Quoted_text, oneOrMore(.Quoted_text_item))
        lexerRule(.Quoted_text_item, notChar(["\"", "\n", "\r", "\\"]))
        
        lexerFragment(.Escaped_character,
            any(
                "\\" ~ char(["0", "\\", "t", "n", "r", "\""]),
                "\\x" ~ .Hexadecimal_digit ~ .Hexadecimal_digit,
                "\\u" ~ "{" ~ times(4, .Hexadecimal_digit) ~ "}",
                "\\u" ~ "{" ~ times(8, .Hexadecimal_digit) ~ "}"
            )
        )
        
        lexerRule(.Interpolated_string_literal,
            "\"" ~ zeroOrMore(.Interpolated_text_item) ~ "\""
        )
        
        lexerFragment(.Interpolated_text_item,
            any(
                "\\(" ~ oneOrMore(~.Interpolated_string_literal | ~.Interpolated_text_item) ~ ")", // nested strings allowed
                ~.Quoted_text_item
            )
        )
        
        // TODO: -> channel(HIDDEN)
        lexerRule(.WS,
            oneOrMore(char([" ", "\n", "\r", "\t", "\u{000B}", "\u{000C}", "\u{0000}"]))
        )
        
        // TODO: -> channel(HIDDEN)
        lexerRule(.Block_comment,
            "/*" ~ lazy(.Block_comment ~ anyChar()) ~ "*/"
        )
        
        // TODO: -> channel(HIDDEN)
        lexerRule(.Line_comment,
            "//" ~ lazy(anyChar()) ~ any(~"\n", eof())
        )
    }
}