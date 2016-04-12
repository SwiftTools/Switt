import Antlr4

class GrammarMath {
    static func unroll<T, U>(context context: T?, @noescape element: T -> U?, @noescape list: T -> T?) -> [U]? {
        if let context = context {
            return unrollFlattened(context: context, element: element, list: list)
        } else {
            return nil
        }
    }
    
    static func unrollFlattened<T, U>(context context: T, @noescape element: T -> U?, @noescape list: T -> T?) -> [U] {
        var contexts: [U] = []
        
        if let left = element(context) {
            contexts.append(left)
        }
        if let right = unroll(context: list(context), element: element, list: list) {
            contexts.appendContentsOf(right)
        }
        
        return contexts
    }
}

extension SyntaxTree {
    func unroll<U>(@noescape element element: Self -> U?, @noescape list: Self -> Self?) -> [U] {
        var contexts: [U] = []
        
        if let left = element(self) {
            contexts.append(left)
        }
        if let right = list(self)?.unroll(element: element, list: list) {
            contexts.appendContentsOf(right)
        }
        
        return contexts
    }
}

extension ParserRuleContext {
    func mapTerminal<T>(map: [Int: T]) -> T? {
        for (tokenType, value) in map {
            let tokensCount = getTokens(tokenType).count
            if tokensCount == 1 {
                return value
            } else if tokensCount > 1 {
                return nil
            }
        }
        
        return nil
    }
}