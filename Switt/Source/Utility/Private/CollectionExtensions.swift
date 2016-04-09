extension CollectionType {
    // Returns element at index or nil if index is out of range
    func at(index: Index) -> Generator.Element? {
        let intIndex = startIndex.distanceTo(index)
        if intIndex >= 0 && intIndex < count {
            return self[index]
        } else {
            return nil
        }
    }
    
}

extension SequenceType where Generator.Element: Hashable {
    func uniquify() -> [Generator.Element] {
        var seenElements: Set<Generator.Element> = []
        var uniqueElements: [Generator.Element] = []
        
        for element in self where !seenElements.contains(element) {
            seenElements.insert(element)
            uniqueElements.append(element)
        }
        
        return uniqueElements
    }
    
    var hashValue: Int {
        return reduce(0) { seed, element in HashMath.combine(seed, element.hashValue) }
    }
}

extension Dictionary {
    mutating func at(key: Key, @autoclosure initial: () -> Value, @noescape modify: (inout Value) -> ()) {
        var value = self[key] ?? initial()
        modify(&value)
        self[key] = value
    }
}