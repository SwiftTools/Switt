protocol Lexer {
    
}

class LexerImpl: Lexer {
    private let lexerRules: LexerRules
    private let tokenizerFactory: TokenizerFactory
    
    init(lexerRules: LexerRules, tokenizerFactory: TokenizerFactory) {
        self.lexerRules = lexerRules
        self.tokenizerFactory = tokenizerFactory
    }
    
    func tokenize(inputStream: CharacterInputStream, outputStream: TokenOutputStream) {
        while let token = nextToken(inputStream) {
            outputStream.putToken(token)
        }
        outputStream.finish()
    }
    
    private func nextToken(inputStream: CharacterInputStream) -> Token? {
        var token: Token?
        
        var tokenizersById = [RuleIdentifier: Tokenizer]()
        let rules = lexerRules.rules
        
        for ruleDefinition in rules {
            tokenizersById[ruleDefinition.identifier] = tokenizerFactory.tokenizer(ruleDefinition.rule)
        }
        
        let startPosition = inputStream.position
        var string: String = ""
        
        while let char = inputStream.getCharacter() {
            inputStream.moveNext()
            string.append(char)
            
            var currentToken: Token?
            
            for ruleDefinition in rules {
                let ruleIdentifier = ruleDefinition.identifier
                
                if let tokenizer = tokenizersById[ruleIdentifier] {
                    
                    switch tokenizer.feed(char) {
                    case .Complete:
                        // If multiple tokens are generated at one iteration of reading stream,
                        // first one will be the result.
                        if currentToken == nil {
                            currentToken = makeToken(
                                ruleIdentifier: ruleIdentifier,
                                string: string,
                                inputStream: inputStream,
                                startPosition: startPosition,
                                endPosition: inputStream.position
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
            
            // Token with longest string will be a result.
            // Token with longest string always appears on next iteration,
            // after token with smaller string
            if currentToken != nil {
                token = currentToken
            }
            
            if tokenizersById.count > 0 {
                // There are rules, try to find longest token
                continue
            } else {
                if let token = token {
                    // Reset position to last token.
                    // This is done, because input stream could be read after finding this token
                    // but no more tokens were found
                    inputStream.resetPosition(token.source.endPosition)
                    break
                } else {
                    // Error: couldn't find token in input stream
                    break
                }
            }
        }
        
        return token
    }
    
    private func makeToken(ruleIdentifier
        ruleIdentifier: RuleIdentifier,
        string: String,
        inputStream: CharacterInputStream,
        startPosition: StreamPosition,
        endPosition: StreamPosition
        ) -> Token {
        return Token(
            source: TokenSource(
                stream: inputStream,
                startPosition: startPosition,
                endPosition: endPosition
            ),
            string: string,
            ruleIdentifier: ruleIdentifier
        )
    }
}