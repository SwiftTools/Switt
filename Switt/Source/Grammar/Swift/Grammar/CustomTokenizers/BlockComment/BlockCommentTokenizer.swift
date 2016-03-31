class BlockCommentTokenizer: Tokenizer {
    private var balance: Int = 0
    private var state: State = .Initial
    private var canNotContinue = false
    
    private enum State {
        case Initial // started or ended closing
        case BeginOpen // "/"
        case BeginClose // "*"
    }
    
    private var balanced: Bool {
        return balance == 0
    }
    
    func feed(char: Character?) -> TokenizerState {
        if canNotContinue {
            return .Fail
        } else {
            let (state, tokenizerState) = continueFeeding(char)
            self.state = state
            return tokenizerState
        }
    }
    
    private func continueFeeding(char: Character?) -> (State, TokenizerState) {
        switch state {
        case .Initial:
            switch char {
            case .Some("/"):
                return (
                    State.BeginOpen,
                    TokenizerState.Possible
                )
            case .Some("*"):
                return (
                    balanced ? State.Initial : State.BeginClose,
                    balanced ? TokenizerState.Fail : TokenizerState.Possible
                )
            case .None:
                return (
                    State.Initial,
                    balanced ? TokenizerState.Fail : TokenizerState.FatalError
                )
            default:
                return (
                    State.Initial,
                    balanced ? TokenizerState.Fail : TokenizerState.Possible
                )
            }
        case .BeginOpen:
            switch char {
            case .Some("*"):
                open()
                assert(!balanced)
                return (
                    State.Initial,
                    TokenizerState.Possible
                )
            case .None:
                return (
                    State.Initial,
                    balanced ? TokenizerState.Fail : TokenizerState.FatalError
                )
            default:
                return (
                    State.Initial,
                    balanced ? TokenizerState.Fail : TokenizerState.Possible
                )
            }
        case .BeginClose:
            switch char {
            case .Some("/"):
                close()
                return (
                    State.Initial,
                    balanced ? TokenizerState.Complete : TokenizerState.Possible
                )
            case .None:
                assert(!balanced)
                return (
                    State.Initial,
                    TokenizerState.FatalError
                )
            default:
                assert(!balanced)
                return (
                    State.Initial,
                    TokenizerState.Possible
                )
            }
        }
    }
    
    private func open() {
        balance += 1
        
    }
    
    private func close() {
        balance -= 1
        if balanced {
            canNotContinue = true
        }
    }
}