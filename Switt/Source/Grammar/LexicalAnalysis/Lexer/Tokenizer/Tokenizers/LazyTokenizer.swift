private struct SequenceRange: Equatable {
    private(set) var startIndex: Int?
    private(set) var endIndex: Int?
    
    mutating func start(index: Int) {
        if startIndex == nil {
            startIndex = index
        }
    }
    
    mutating func complete(index: Int) {
        if startIndex == nil {
            startIndex = index
        }
        endIndex = index
    }
    
    mutating func reset() {
        startIndex = nil
        endIndex = nil
    }
    
    var isComplete: Bool {
        return startIndex != nil && endIndex != nil
    }
    
    var completeRange: Range<Int>? {
        if let startIndex = startIndex, endIndex = endIndex {
            return startIndex..<endIndex
        } else {
            return nil
        }
    }
}

private func ==(left: SequenceRange, right: SequenceRange) -> Bool {
    return left.startIndex == right.startIndex && left.endIndex == right.endIndex
}

private enum LazyTokenizerException: ErrorType {
    case FatalError
}

class LazyTokenizer: Tokenizer {
    // There's no reason to store startRule, because it's tokenizer is generated once
    private let repeatingRule: LexerRule
    private let stopRule: LexerRule
    
    private let tokenizerFactory: TokenizerFactory
    
    private var startTokenizer: Tokenizer
    private var repeatingTokenizer: Tokenizer
    private var stopTokenizer: Tokenizer
    
    private var repeatingTokenizerRanges: [SequenceRange] = []
    
    private var repeatingTokenizerRange: SequenceRange = SequenceRange()
    private var stopTokenizerRange: SequenceRange = SequenceRange()
    private var index: Int = 0
    
    // TODO: reduce state, separate state
    // TODO: there is really about 4 or 5 states. It can be an enum.
    private var canFeedRepeatingTokenizer: Bool = true
    private var canFeedStopTokenizer: Bool = true
    
    // This flags are not same.
    // shouldComleteStartTokenizer - should feed start tokenizer
    // startTokenizerWasComplete - continue feeding start tokenizer until it fails (then shouldComleteStartTokenizer=false)
    // Possible combinations: (true, false), (true, true), (false, true)
    private var shouldComleteStartTokenizer: Bool = true
    private var startTokenizerWasComplete: Bool = false
    
    // TODO: rename rule to repeatingRule
    init(startRule: LexerRule, rule: LexerRule, stopRule: LexerRule, tokenizerFactory: TokenizerFactory) {
        self.repeatingRule = rule
        self.stopRule = stopRule
        self.tokenizerFactory = tokenizerFactory
        
        self.startTokenizer = tokenizerFactory.tokenizer(startRule)
        self.repeatingTokenizer = tokenizerFactory.tokenizer(rule)
        self.stopTokenizer = tokenizerFactory.tokenizer(stopRule)
    }
    
    func feedRepeatingTokenizerWithFallback(char: Character?, @noescape onFail: () throws -> ()) throws {
        let repeatingTokenizerState = repeatingTokenizer.feed(char)
        
        switch repeatingTokenizerState {
        case .Complete:
            repeatingTokenizerRange.complete(index)
        case .Possible:
            repeatingTokenizerRange.start(index)
        case .Fail:
            try onFail()
        case .FatalError:
            throw LazyTokenizerException.FatalError
        }
    }
    
    func feedStopTokenizerWithFallback(char: Character?, @noescape onFail: () throws -> ()) throws {
        let stopTokenizerState = stopTokenizer.feed(char)
        
        switch stopTokenizerState {
        case .Complete:
            stopTokenizerRange.complete(index)
            
            canFeedRepeatingTokenizer = false
            canFeedStopTokenizer = false
        case .Possible:
            stopTokenizerRange.start(index)
        case .Fail:
            try onFail()
        case .FatalError:
            throw LazyTokenizerException.FatalError
        }
    }
    
    func feedRepeatingTokenizer(char: Character?) throws {
        try feedRepeatingTokenizerWithFallback(char) {
            if repeatingTokenizerRange.isComplete {
                repeatingTokenizerRanges.append(repeatingTokenizerRange)
                
                // Reset
                repeatingTokenizerRange.reset()
                repeatingTokenizer = tokenizerFactory.tokenizer(repeatingRule)
                
                try feedRepeatingTokenizerWithFallback(char) {
                    repeatingTokenizerRange.reset()
                    canFeedRepeatingTokenizer = false
                }
            } else {
                repeatingTokenizerRange.reset()
                canFeedRepeatingTokenizer = false
            }
        }
    }
    
    func feedStopTokenizer(char: Character?) throws {
        try feedStopTokenizerWithFallback(char) {
            // Reset
            stopTokenizerRange.reset()
            stopTokenizer = tokenizerFactory.tokenizer(stopRule)
            
            try feedStopTokenizerWithFallback(char) {
                // Reset
                stopTokenizerRange.reset()
                stopTokenizer = tokenizerFactory.tokenizer(stopRule)
                
                if !canFeedRepeatingTokenizer {
                    canFeedStopTokenizer = false
                }
            }
        }
    }
    
    func feedStartOrRepeatingOrStopTokenizer(char: Character?) -> TokenizerState {
        switch startTokenizer.feed(char) {
        case .Possible:
            return .Possible
        case .Fail:
            if !startTokenizerWasComplete {
                return .Fail
            } else {
                shouldComleteStartTokenizer = false
                return feedRepeatingOrStopTokenizer(char)
            }
        case .Complete:
            startTokenizerWasComplete = true
            return .Possible
        case .FatalError:
            return .FatalError
        }
    }
    
    func feed(char: Character?) -> TokenizerState {
        if shouldComleteStartTokenizer {
            return feedStartOrRepeatingOrStopTokenizer(char)
        } else {
            return feedRepeatingOrStopTokenizer(char)
        }
    }
    
    func feedRepeatingOrStopTokenizer(char: Character?) -> TokenizerState {
        do {
            if canFeedRepeatingTokenizer {
                try feedRepeatingTokenizer(char)
            }
            
            if canFeedStopTokenizer {
                try feedStopTokenizer(char)
            }
            
            let lastObtainedRanges: [SequenceRange]
            
            if stopTokenizerRange == repeatingTokenizerRange {
                // ok
                lastObtainedRanges = [stopTokenizerRange]
            } else {
                lastObtainedRanges = [repeatingTokenizerRange, stopTokenizerRange]
            }
            
            let allRanges = (repeatingTokenizerRanges + lastObtainedRanges).flatMap { $0.completeRange }
            var iteratedRange = 0..<0
            
            let fullRange = 0...index
            
            index = index + 1
            
            for range in allRanges {
                if iteratedRange.endIndex == range.startIndex {
                    iteratedRange.endIndex = range.endIndex + 1
                } else {
                    // E.g.: (abc)*? cd after "abcd"
                    // allRanges = [0..<2, 2..<3] - "abc" intersects "cd"
                    // globalRange = [0..<3]
                    return .Fail
                }
            }
            
            
            if iteratedRange == fullRange {
                // E.g.: (abc)*? cd after "abccd"
                // allRanges = [0...2, 3...4]
                // globalRange = [0...4]
                
                if stopTokenizerRange.isComplete {
                    return .Complete
                } else {
                    if canFeedStopTokenizer {
                        return .Possible
                    } else {
                        return .Fail
                    }
                }
            } else {
                if canFeedStopTokenizer {
                    // E.g.: (abc)*? cd after "abcc"
                    // allRanges = [0...2, 3...3]
                    // globalRange = [0...4]
                    return .Possible
                } else {
                    // E.g.: (abc)*? cd after "abcad"
                    // allRanges = [0...2]
                    // globalRange = [0...4]
                    return .Fail
                }
            }
        } catch {
            return .FatalError
        }
    }
}