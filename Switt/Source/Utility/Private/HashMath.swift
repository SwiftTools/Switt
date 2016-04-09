struct HashCombine {
    let reduce: Int
    
    @inline(__always) func combine<T: Hashable>(hashable: T) -> HashCombine {
        return HashCombine(reduce: HashMath.combine(reduce, hashable.hashValue))
    }
}

class HashMath {
    @inline(__always) static func combine<T: Hashable>(hashable: T) -> HashCombine {
        return HashCombine(reduce: hashable.hashValue)
    }
    
    @inline(__always) static func combine(left: Int, _ right: Int) -> Int {
        return left ^ (
            addWithOverflow(
                addWithOverflow(
                    addWithOverflow(
                        right,
                        0x9e3779b9
                    ),
                    left << 6
                ),
                left >> 2
            )
        )
    }
    
    private static func addWithOverflow(lhs: Int, _ rhs: Int) -> Int {
        return Int.addWithOverflow(lhs, rhs).0
    }
}