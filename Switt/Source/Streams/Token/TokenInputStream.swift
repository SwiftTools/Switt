protocol TokenStreamAccessable {
    // Get current token
    func token() -> Token?
    
    // Get token, relative to current position
    // 0: Current token
    // 1: Next token
    // -1: Previous token
    func tokenAt(index: Int) -> Token?
}

protocol TokenStreamPositionable {
    var position: StreamPosition { get }
    
    func moveNext()
}

protocol TokenInputStream: TokenStreamAccessable, TokenStreamPositionable {
}

extension TokenInputStream {
    // Last token in stream
    func token() -> Token? {
        return tokenAt(0)
    }
    
    func filtered(includeElement: Token -> Bool) -> TokenInputStream {
        return FilteredTokenInputStream(stream: self, filter: includeElement)
    }
    
    func filtered(channel channel: TokenChannel) -> TokenInputStream {
        return FilteredTokenInputStream(stream: self, filter: { token in token.channel == channel })
    }
    
    func defaultChannel() -> TokenInputStream {
        return filtered(channel: .Default)
    }
}