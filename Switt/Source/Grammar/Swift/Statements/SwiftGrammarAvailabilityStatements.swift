class SwiftGrammarAvailabilityStatements: GrammarRulesRegistrator {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        parserRule(.availability_condition,
            compound(
                required("#available"),
                required("("),
                required(.availability_arguments),
                required(")")
            )
        )
        
        parserRule(.availability_arguments,
            compound(
                required(.availability_argument),
                zeroOrMore(
                    required(","),
                    required(.availability_argument)
                )
            )
        )
        
        parserRule(.availability_argument,
            any(
                required(.Platform),
                required("*")
            )
        )
        
        // Must match as token so Platform_version doesn't look like a float literal
        lexerRule(.Platform,
            compound(
                required(.Platform_name),
                optional(.WS),
                required(.Platform_version)
            )
        )
        
        lexerFragment(.Platform_name,
            any(
                "iOS",
                "iOSApplicationExtension",
                "OSX",
                "OSXApplicationExtension",
                "watchOS",
                "tvOS"
            )
        )
        
        lexerFragment(.Platform_version,
            ~.Pure_decimal_digits
            | ~.Pure_decimal_digits ~ "." ~ .Pure_decimal_digits
            | ~.Pure_decimal_digits ~ "." ~ .Pure_decimal_digits ~ "." ~ .Pure_decimal_digits
        )
    }
}