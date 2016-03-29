class StreamPosition: Comparable {
    private let restoreFunction: () -> ()
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