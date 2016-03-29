@testable import Switt

class TokenInputOutputStream: TokenInputStream, TokenOutputStream {
    private(set) var index: Int = 0
    private(set) var tokens: [Token] = []
    
    var position: StreamPosition {
        return positionForIndex(index)
    }
    
    func positionForIndex(index: Int) -> StreamPosition {
        return StreamPosition(
            restoreFunction: { [weak self, savedIndex = index] in
                self?.index = savedIndex
            },
            distanceToCurrent: { [weak self, savedIndex = index] in
                return (self?.index ?? 0) - savedIndex
            }
        )
    }
    
    func tokenAt(relativeIndex: Int) -> Token? {
        let forwardIndex = index + relativeIndex
        return tokens.at(forwardIndex)
    }
    
    func moveNext() {
        index += 1
    }
    
    func putToken(token: Token) {
        tokens.append(token)
    }
    
    func finish() {
    }
}