@testable import Switt

// Index is public
class TokenInputStreamTestable: TokenInputStream {
    private(set) var index: Int = 0
    private let stream: TokenInputStream
    
    var position: StreamPosition {
        return StreamPosition(
            restoreFunction: { [weak self, savedIndex = index, position = stream.position] in
                self?.index = savedIndex
                position.restore()
            },
            distanceToCurrent: { [weak self, savedIndex = index] in
                return (self?.index ?? 0) - savedIndex
            }
        )
    }
    
    init(stream: TokenInputStream) {
        self.stream = stream
    }
    
    func getToken() -> Token? {
        return stream.getToken()
    }
    
    func moveNext() {
        index += 1
        stream.moveNext()
    }
}