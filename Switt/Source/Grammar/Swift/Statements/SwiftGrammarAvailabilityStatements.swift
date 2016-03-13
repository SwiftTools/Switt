class SwiftGrammarAvailabilityStatements: GrammarRulesBuilder {
    var grammarRules: GrammarRules = GrammarRules()
    
    func registerRules() {
        clearRules()
        
        register(.availability_condition,
            compound(
                required("#available"),
                required("("),
                required(.availability_arguments),
                required(")")
            )
        )
        
        register(.availability_arguments,
            compound(
                required(.availability_argument),
                zeroOrMore(
                    required(","),
                    required(.availability_argument)
                )
            )
        )
        
        register(.availability_argument,
            any(
                required(.Platform),
                required("*")
            )
        )
        
        // Must match as token so Platform_version doesn't look like a float literal
        register(.Platform,
            compound(
                required(.Platform_name),
                optional(.WS),
                required(.Platform_version)
            )
        )
        
        registerFragment(.Platform_name,
            any(
                "iOS",
                "iOSApplicationExtension",
                "OSX",
                "OSXApplicationExtension",
                "watchOS",
                "tvOS"
            )
        )
        
        registerFragment(.Platform_version,
            ~.Pure_decimal_digits
            | ~.Pure_decimal_digits ~ "." ~ .Pure_decimal_digits
            | ~.Pure_decimal_digits ~ "." ~ .Pure_decimal_digits ~ "." ~ .Pure_decimal_digits
        )
    }
}