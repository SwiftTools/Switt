class SwiftGrammarAvailabilityStatements: LexemeBuilder {
    var lexemes: [LexemeType: Lexeme] = [:]
    var fragments: [LexemeType: Lexeme] = [:]
    
    func registerLexemes() {
        clearLexemes()
        
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
                optional(.WS), // TODO
                required(.Platform_version)
            )
        )
        
        /*
        fragment
        register(.Platform_name, compound( required("iOS") | required("iOSApplicationExtension") | required("OSX") | required("OSXApplicationExtension") | required("watchOS") | required("tvOS")  )
        
        fragment
        register(.Platform_version, compound(  required(.Pure_decimal_digits) | Pure_decimal_digits required(".") Pure_decimal_digits | Pure_decimal_digits required(".") Pure_decimal_digits required(".") Pure_decimal_digits )
        */
    }
}