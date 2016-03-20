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