class StreamPosition: Comparable {
    private let restoreFunction: () -> ()
    
    // Saved index: 0
    // Current index: 1
    // Distance: 1
    private let distanceToCurrent: () -> Int
    
    init(restoreFunction: () -> (), distanceToCurrent: () -> Int) {
        self.restoreFunction = restoreFunction
        self.distanceToCurrent = distanceToCurrent
    }
    
    func restore() {
        restoreFunction()
    }
}

func ==(left: StreamPosition, right: StreamPosition) -> Bool {
    return left.distanceToCurrent() == right.distanceToCurrent()
}

func <(left: StreamPosition, right: StreamPosition) -> Bool {
    return left.distanceToCurrent() > right.distanceToCurrent()
}

func >(left: StreamPosition, right: StreamPosition) -> Bool {
    return left.distanceToCurrent() < right.distanceToCurrent()
}

func <=(left: StreamPosition, right: StreamPosition) -> Bool {
    return left.distanceToCurrent() >= right.distanceToCurrent()
}

func >=(left: StreamPosition, right: StreamPosition) -> Bool {
    return left.distanceToCurrent() <= right.distanceToCurrent()
}