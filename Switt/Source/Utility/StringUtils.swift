class StringUtils {
    static let indentation = "    "
    static let newLine = "\n"
    
    static func indent(string: String, indentation: String = indentation) -> String {
        return string
            .componentsSeparatedByString(newLine)
            .map { indentation + $0 }
            .joinWithSeparator(newLine)
    }
    
    static func wrapAndIndent(prefix prefix: String, infix: String, postfix: String) -> String {
        return prefix + newLine
            + indent(infix) + newLine
            + postfix
    }
    
    // Goal: you can pass large expression to string attribute
    // map("<b>" + str + "</b>") { "<i>" + $0 + ": " + "$0" + "</i>" }
    private static func map(string: String, @noescape _ map: String -> String) -> String {
        return map(string)
    }

    private static func mapIf(condition: Bool, _ string: String, @noescape _ map: String -> String) -> String {
        if condition {
            return map(string)
        } else {
            return string
        }
    }
    
    private static func mapIfNotEmpty(string: String, @noescape _ map: String -> String) -> String {
        return mapIf(!string.isEmpty, string, map)
    }
}