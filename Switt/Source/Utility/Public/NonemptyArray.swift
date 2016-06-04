public struct NonemptyArray<T> {
    public var first: T {
        didSet {
            array = [first] + latter
        }
    }
    public var latter: [T] {
        didSet {
            array = [first] + latter
        }
    }
    
    public private(set) var array: [T]
    
    public init(first: T, latter: [T] = []) {
        self.first = first
        self.latter = latter
        self.array = [first] + latter
    }
    
    public init?(array: [T]) {
        if let first = array.first {
            self.first = first
            self.latter = array.dropFirst().map { $0 }
            self.array = array
        } else {
            return nil
        }
    }
    
    public var count: Int {
        return array.count
    }
}