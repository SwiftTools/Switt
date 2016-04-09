class Lazy<T> {
    let creation:  () -> T
    lazy private(set) var value: T = { return self.creation() }()
    
    init(@autoclosure(escaping) _ creation: () -> T) {
        self.creation = creation
    }
}