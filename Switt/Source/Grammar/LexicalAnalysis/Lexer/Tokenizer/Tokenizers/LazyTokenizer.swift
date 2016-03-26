private struct SequenceRange {
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

class LazyTokenizer: Tokenizer {
    private let repeatingRule: LexerRule
    private let stopRule: LexerRule
    private let stopRuleIsRequired: Bool
    
    private let tokenizerFactory: TokenizerFactory
    
    private var repeatingTokenizer: Tokenizer
    private var stopTokenizer: Tokenizer
//    
//    private var repeatingTokenizerWasComplete: Bool = true
//    private var repeatingTokenizerWasCompletelyFailed: Bool = false
//    private var wholeTokenizerWasComplete: Bool = false
//    private var wholeTokenizerWasFailed: Bool = false
//    
//    private var shouldCheckStopTokenizerFromBeginningTillEnd: Bool = false
    
    private var repeatingTokenizerRanges: [SequenceRange] = []
    
    private var repeatingTokenizerRange: SequenceRange = SequenceRange()
    private var stopTokenizerRange: SequenceRange = SequenceRange()
    private var index: Int = 0
    
    private var canFeedRepeatingTokenizer: Bool = true
    private var canFeedStopTokenizer: Bool = true
    
    init(rule: LexerRule, stopRule: LexerRule, stopRuleIsRequired: Bool, tokenizerFactory: TokenizerFactory) {
        self.repeatingRule = rule
        self.stopRule = stopRule
        self.stopRuleIsRequired = stopRuleIsRequired
        self.tokenizerFactory = tokenizerFactory
        
        self.repeatingTokenizer = tokenizerFactory.tokenizer(rule)
        self.stopTokenizer = tokenizerFactory.tokenizer(stopRule)
    }
    
    func feedRepeatingTokenizerWithFallback(char: Character, @noescape onFail: () -> ()) {
        let repeatingTokenizerState = repeatingTokenizer.feed(char)
        
        switch repeatingTokenizerState {
        case .Complete:
            repeatingTokenizerRange.complete(index)
        case .Possible:
            repeatingTokenizerRange.start(index)
        case .Fail:
            onFail()
        }
    }
    
    func feedStopTokenizerWithFallback(char: Character, @noescape onFail: () -> ()) {
        let repeatingTokenizerState = stopTokenizer.feed(char)
        
        switch repeatingTokenizerState {
        case .Complete:
            stopTokenizerRange.complete(index)
            
            canFeedRepeatingTokenizer = false
            canFeedStopTokenizer = false
        case .Possible:
            stopTokenizerRange.start(index)
        case .Fail:
            onFail()
        }
    }
    
    func feedRepeatingTokenizer(char: Character) {
        feedRepeatingTokenizerWithFallback(char) {
            if repeatingTokenizerRange.isComplete {
                repeatingTokenizerRanges.append(repeatingTokenizerRange)
                
                // Reset
                repeatingTokenizerRange.reset()
                repeatingTokenizer = tokenizerFactory.tokenizer(repeatingRule)
                
                feedRepeatingTokenizerWithFallback(char) {
                    repeatingTokenizerRange.reset()
                    canFeedRepeatingTokenizer = false
                }
            } else {
                repeatingTokenizerRange.reset()
                canFeedRepeatingTokenizer = false
            }
        }
    }
    
    func feedStopTokenizer(char: Character) {
        feedStopTokenizerWithFallback(char) {
            // Reset
            stopTokenizerRange.reset()
            stopTokenizer = tokenizerFactory.tokenizer(stopRule)
            
            feedStopTokenizerWithFallback(char) {
                // Reset
                stopTokenizerRange.reset()
                stopTokenizer = tokenizerFactory.tokenizer(stopRule)
                
                if !canFeedRepeatingTokenizer {
                    canFeedStopTokenizer = false
                }
            }
        }
    }
    
    func feed(char: Character) -> TokenizerState {
        if canFeedRepeatingTokenizer {
            feedRepeatingTokenizer(char)
        }
        
        if canFeedStopTokenizer {
            feedStopTokenizer(char)
        }
        
        let allRanges = (repeatingTokenizerRanges + [repeatingTokenizerRange, stopTokenizerRange]).flatMap { $0.completeRange }
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
            
            if !stopRuleIsRequired {
                return .Complete
            } else {
                if stopTokenizerRange.isComplete {
                    return .Complete
                } else {
                    if canFeedStopTokenizer {
                        return .Possible
                    } else {
                        return .Fail
                    }
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
    }
//
//    func feed(char: Character) -> TokenizerState {
//        if shouldCheckStopTokenizerFromBeginningTillEnd {
//            return feedStopTokenizer(char)
//        } else {
//            return feedBothTokenizers(char)
//        }
//    }
//    
//    func feedStopTokenizer(char: Character) -> TokenizerState {
//        return stopTokenizer.feed(char)
//    }
//    
//    func feedBothTokenizers(char: Character) -> TokenizerState {
//        if wholeTokenizerWasFailed {
//            return .Fail
//        } else {
//            var stopTokenizerWasReset = false
//            var stopTokenizerState = stopTokenizer.feed(char)
//            let repeatingTokenizerState = repeatingTokenizer.feed(char)
//            
//            // Feed stop tokenizer
//            switch stopTokenizerState {
//            case .Fail:
//                if wholeTokenizerWasComplete {
//                    return .Fail
//                } else {
//                    stopTokenizerWasReset = true
//                    var result: TokenizerState?
//                    (result, stopTokenizerState) = retryFeedStopTokenizer(char)
//                    if let result = result {
//                        return result
//                    }
//                }
//            case .Complete:
//                if repeatingTokenizerWasComplete {
//                    wholeTokenizerWasComplete = true
//                    return .Complete
//                } else {
//                    wholeTokenizerWasFailed = true
//                    return .Fail
//                }
//            case .Possible:
//                break
//            }
//            
//            // Feed repeating tokenizer
//            switch repeatingTokenizerState {
//            case .Fail:
//                return retryFeedRepeatingTokenizer(
//                    char: char,
//                    stopTokenizerState: stopTokenizerState,
//                    stopTokenizerWasReset: stopTokenizerWasReset
//                )
//            case .Complete:
//                repeatingTokenizerWasComplete = true
//                
//                if !required {
//                    return .Complete
//                } else {
//                    return .Possible
//                }
//            case .Possible:
//                repeatingTokenizerWasComplete = false
//                return .Possible
//            }
//        }
//    }
//    
//    func retryFeedRepeatingTokenizer(char
//        char: Character,
//        stopTokenizerState: TokenizerState,
//        stopTokenizerWasReset: Bool
//        ) -> TokenizerState
//    {
//        var repeatingTokenizerState = TokenizerState.Fail
//        if repeatingTokenizerWasComplete {
//            // Try repeat
//            repeatingTokenizer = tokenizerFactory.tokenizer(rule)
//            repeatingTokenizerState = repeatingTokenizer.feed(char)
//        }
//        
//        switch repeatingTokenizerState {
//        case .Fail:
//            let wasCompleteBeforeLastFeed = repeatingTokenizerWasComplete
//            
//            repeatingTokenizerWasComplete = false
//            repeatingTokenizerWasCompletelyFailed = true
//            switch stopTokenizerState {
//            case .Complete:
//                assertionFailure("should never happen")
//                return .Fail
//            case .Fail:
//                wholeTokenizerWasFailed = true
//                return .Fail
//            case .Possible:
//                if wasCompleteBeforeLastFeed && stopTokenizerWasReset {
//                    shouldCheckStopTokenizerFromBeginningTillEnd = true
//                }
//                return .Possible
//            }
//        case .Possible:
//            repeatingTokenizerWasComplete = false
//            
//            return .Possible
//        case .Complete:
//            repeatingTokenizerWasComplete = true
//            
//            if !required {
//                return .Complete
//            } else {
//                return .Possible
//            }
//        }
//    }
//    
//    func retryFeedStopTokenizer(char: Character) -> (result: TokenizerState?, stopTokenizerState: TokenizerState) {
//        // Retry from beginning
//        stopTokenizer = tokenizerFactory.tokenizer(stopRule)
//        let stopTokenizerState = stopTokenizer.feed(char)
//        switch stopTokenizerState {
//        case .Fail:
//            if repeatingTokenizerWasCompletelyFailed {
//                wholeTokenizerWasFailed = true
//                return (.Fail, stopTokenizerState)
//            } else {
//                // Reset
//                stopTokenizer = tokenizerFactory.tokenizer(stopRule)
//            }
//        case .Complete:
//            if repeatingTokenizerWasComplete {
//                wholeTokenizerWasComplete = true
//                return (.Complete, stopTokenizerState)
//            } else {
//                wholeTokenizerWasFailed = true
//                return (.Fail, stopTokenizerState)
//            }
//        case .Possible:
//            break
//        }
//        
//        return (nil, stopTokenizerState)
//    }
}