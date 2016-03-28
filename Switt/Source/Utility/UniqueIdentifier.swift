class UniqueIdentifier: Hashable {
    let hashValue: Int = random()
}

func ==(left: UniqueIdentifier, right: UniqueIdentifier) -> Bool {
    return left === right
}