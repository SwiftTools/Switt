protocol Lexer {
    func tokenize(inputStream: CharacterInputStream) -> TokenInputStream
}

private struct BestToken {
    var ruleIdentifier: RuleIdentifier
    var string: String
    var channel: TokenChannel
    var nextCharPosition: CharacterStreamPosition
}

class LexerImpl: Lexer {
    private let lexerRules: LexerRules
    private let tokenizerFactory: TokenizerFactory
    
    init(lexerRules: LexerRules, tokenizerFactory: TokenizerFactory) {
        self.lexerRules = lexerRules
        self.tokenizerFactory = tokenizerFactory
    }
    
    func tokenize(inputStream: CharacterInputStream) -> TokenInputStream {
        return LexerTokenStream(inputStream: inputStream, lexerRules: lexerRules, tokenizerFactory: tokenizerFactory)
    }
}

class LexerTokenStream: TokenInputStream {
    private var currentIndex: Int = 0
    private var tokens: [Token] = []
    
    private let inputStream: CharacterInputStream
    private let lexerRules: LexerRules
    private let tokenizerFactory: TokenizerFactory
    
    init(inputStream: CharacterInputStream, lexerRules: LexerRules, tokenizerFactory: TokenizerFactory) {
        self.lexerRules = lexerRules
        self.tokenizerFactory = tokenizerFactory
        self.inputStream = inputStream
    }
    
    var position: StreamPosition {
        return positionForIndex(currentIndex)
    }
    
    private func positionForIndex(index: Int) -> StreamPosition {
        return StreamPosition(
            restoreFunction: { [weak self] in
                self?.currentIndex = index
            },
            distanceToCurrent: { [weak self] in
                return (self?.currentIndex ?? 0) - index
            }
        )
    }
    
    func tokenAt(relativeIndex: Int) -> Token? {
        let tokenAtIndex: Token?
        let savedPosition = position
        
        let index = currentIndex + relativeIndex
        
        if index < 0 {
            tokenAtIndex = nil
        } else if index < tokens.count {
            tokenAtIndex = tokens.at(index)
        } else {
            var tokensToGet = index - tokens.count + 1
            
            while tokensToGet > 0, let bestToken = nextToken() {
                let token = Token(
                    string: bestToken.string,
                    ruleIdentifier: bestToken.ruleIdentifier,
                    channel: bestToken.channel,
                    source: TokenSource(
                        stream: self,
                        position: positionForIndex(tokens.count)
                    )
                )
                tokens.append(token)
                tokensToGet -= 1
            }
            
            let successfullyGotLastToken = tokensToGet == 0
            
            tokenAtIndex = successfullyGotLastToken ? tokens.last : nil
        }
        
        savedPosition.restore()
        return tokenAtIndex
    }
    
    func moveNext() {
        currentIndex += 1
    }
    
    private func nextToken() -> BestToken? {
        var bestToken: BestToken?
        
        var tokenizersById = [RuleIdentifier: Tokenizer]()
        var rules = lexerRules.rules
        
        for ruleDefinition in rules {
            tokenizersById[ruleDefinition.identifier] = tokenizerFactory.tokenizer(ruleDefinition.rule)
        }
        
        var string: String = ""
        
        while let char = inputStream.getCharacter() {
            inputStream.moveNext()
            let nextCharPosition = inputStream.position
            string.append(char)
            
            var currentToken: BestToken?
            
            for ruleDefinition in rules {
                let ruleIdentifier = ruleDefinition.identifier
                
                if let tokenizer = tokenizersById[ruleIdentifier] {
                    
                    switch tokenizer.feed(char) {
                    case .Complete:
                        // If multiple tokens are generated at one iteration of reading stream,
                        // first one will be the result.
                        if currentToken == nil {
                            currentToken = BestToken(
                                ruleIdentifier: ruleIdentifier,
                                string: string,
                                channel: ruleDefinition.channel,
                                nextCharPosition: nextCharPosition
                            )
                        }
                        // Complete doesn't mean that tokenizer can not make longer token
                        // It means that token can be created
                    case .Fail:
                        tokenizersById.removeValueForKey(ruleIdentifier)
                    case .Possible:
                        break
                    }
                }
            }
            
            rules = rules.filter { rule in tokenizersById[rule.identifier] != nil }
            
            // Token with longest string will be a result.
            // Token with longest string always appears on next iteration,
            // after token with smaller string
            if currentToken != nil {
                bestToken = currentToken
            }
            
            if tokenizersById.count > 0 {
                // There are rules, try to find longest token
                continue
            } else {
                if let bestToken = bestToken {
                    // Reset position to last token.
                    // This is done, because input stream could be read after finding this token
                    // but no more tokens were found
                    bestToken.nextCharPosition.restore()
                    break
                } else {
                    // Error: couldn't find token in input stream
                    break
                }
            }
        }
        
        return bestToken
    }
}