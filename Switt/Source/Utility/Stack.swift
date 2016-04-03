struct Stack<T> {
    var array: [T]
    var index: Int = -1
    
    mutating func push(value: T) {
        array.append(value)
    }
    
    func top() -> T? {
        return array.at(index)
    }
    
    mutating func pop() -> T? {
        if let value = array.at(index) {
            index -= 1
            return value
        } else {
            return nil
        }
    }
}