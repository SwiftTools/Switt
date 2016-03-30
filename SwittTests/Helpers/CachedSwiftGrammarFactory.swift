@testable import Switt

class CachedSwiftGrammarFactory: GrammarFactory {
    private let cachedGrammar = SwiftGrammarFactory().grammar()
    
    func grammar() -> Grammar {
        return cachedGrammar
    }
    
    static let instance = CachedSwiftGrammarFactory()
}