struct Position {
    private var index: String.Index
}

class InputStringStream {
    private var string: String
    private var index: String.Index
    
    init(string: String) {
        self.string = string
        index = string.startIndex
    }
    
    func position() -> Position {
        return Position(index: index)
    }
    
    func resetPosition(position: Position) {
        index = position.index
    }
    
    func getCharacter() -> Character? {
        return string[index]
    }
    
    func moveNext() {
        index = index.advancedBy(1)
    }
}

enum ParseTreeNode {
    case Leaf(String)
    case Tree(ParseTree)
}

struct ParseTree {
    var name: RuleName
    var nodes: [ParseTreeNode]
    
    init(name: RuleName, nodes: [ParseTreeNode]) {
        self.name = name
        self.nodes = nodes
    }
}

enum ParserResult {
    case Fail
    case Success
    case Terminal(String)
    case Nodes([ParseTreeNode])
    case Tree(ParseTree)
}

typealias LexicalAnalysisResult = ParserResult

class ProductionRuleScannerOutputStream {
    
}

protocol ProductionRuleScanner {
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult
}

enum RuleContext {
    case Lexer
    case Parser
}

struct ProductionRuleScannerInput {
    var inputStream: InputStringStream
    var grammar: Grammar
    var ruleContext: RuleContext
}

class AnyProductionRuleScanner: ProductionRuleScanner {
    let rule: ProductionRule
    let input: ProductionRuleScannerInput
    
    init(rule: ProductionRule, input: ProductionRuleScannerInput) {
        self.rule = rule
        self.input = input
    }
    
    @warn_unused_result
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        let scanner: ProductionRuleScanner
        
        switch rule {
        case .CharRanges(let positive, let ranges):
            scanner = CharRangesProductionRuleScanner(
                input: input,
                positive: positive,
                ranges: ranges
            )
        case .Check(let checkFunction):
            scanner = CheckProductionRuleScanner(
                input: input,
                checkFunction: checkFunction
            )
        case .Compound(let productionRules):
            scanner = CompoundProductionRuleScanner(
                input: input,
                productionRules: productionRules
            )
        case .Empty:
            scanner = EmptyProductionRuleScanner()
        case .Eof:
            scanner = EofProductionRuleScanner(
                input: input
            )
        case .Multiple(let times, let rule):
            scanner = MultipleProductionRuleScanner(
                input: input,
                times: times,
                rule: rule
            )
        case .Optional(let optionalRule):
            scanner = OptionalProductionRuleScanner(
                input: input,
                rule: optionalRule
            )
        case .Or(let productionRules):
            scanner = VariantsProductionRuleScanner(
                input: input,
                productionRules: productionRules
            )
        case .Reference(let ruleName):
            scanner = ReferenceProductionRuleScanner(input: input, ruleName: ruleName)
        case .StringRule(let string):
            scanner = TerminalProductionRuleScanner(
                input: input,
                terminal: string
            )
        }
        
        let result = scanner.scan(outputStream)
        
        switch result {
        case .Fail:
            input.inputStream.resetPosition(position)
            return .Fail
        default:
            return result
        }
    }
}

class OptionalProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    let rule: ProductionRule
    
    init(input: ProductionRuleScannerInput, rule: ProductionRule) {
        self.input = input
        self.rule = rule
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        let scanner = AnyProductionRuleScanner(rule: rule, input: input)
        let result = scanner.scan(outputStream)
        switch result {
        case .Fail:
            input.inputStream.resetPosition(position)
            return .Success
        default:
            return result
        }
    }
}

class MultipleProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    let times: UInt
    let rule: ProductionRule
    
    init(input: ProductionRuleScannerInput, times: UInt, rule: ProductionRule) {
        self.input = input
        self.times = times
        self.rule = rule
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        var productionRules = [ProductionRule]()
        for _ in 0..<times {
            productionRules.append(rule)
        }
        let scanner = CompoundProductionRuleScanner(input: input, productionRules: productionRules)
        let result = scanner.scan(outputStream)
        switch result {
        case .Fail:
            input.inputStream.resetPosition(position)
            return .Fail
        default:
            return result
        }
    }
}

class ReferenceProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    let ruleName: RuleName
    
    init(input: ProductionRuleScannerInput, ruleName: RuleName) {
        self.input = input
        self.ruleName = ruleName
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        if let rule = input.grammar.rules.rules[ruleName] {
            var subinput = input
            subinput.ruleContext = input.grammar.contextCheckFunction(ruleName)
            let scanner = AnyProductionRuleScanner(rule: rule, input: subinput)
            let parserResult = scanner.scan(outputStream)
            
            let nodes: [ParseTreeNode]
            
            switch parserResult {
            case .Fail:
                input.inputStream.resetPosition(position)
                return .Fail
            case .Nodes(let subnodes):
                nodes = subnodes
            case .Success:
                nodes = []
            case .Terminal(let terminal):
                nodes = [ParseTreeNode.Leaf(terminal)]
            case .Tree(let tree):
                nodes = [ParseTreeNode.Tree(tree)]
            }
            
            let tree = ParseTree(name: ruleName, nodes: nodes)
            
            return ParserResult.Tree(tree)
            
        } else if let fragment = input.grammar.rules.fragments[ruleName] {
            var subinput = input
            subinput.ruleContext = input.grammar.contextCheckFunction(ruleName)
            let scanner = AnyProductionRuleScanner(rule: fragment, input: subinput)
            let parserResult = scanner.scan(outputStream)
            switch parserResult {
            case .Fail:
                input.inputStream.resetPosition(position)
                return .Fail
            default:
                return parserResult
            }
        } else {
            input.inputStream.resetPosition(position)
            return .Fail
        }
    }
}

class EofProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    
    init(input: ProductionRuleScannerInput) {
        self.input = input
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        if input.inputStream.getCharacter() == nil {
            return .Success
        } else {
            return .Fail
        }
    }
}

class EmptyProductionRuleScanner: ProductionRuleScanner {
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        return .Success
    }
}

class CompoundProductionRuleScanner: ProductionRuleScanner {
    let productionRules: [ProductionRule]
    let input: ProductionRuleScannerInput
    
    init(input: ProductionRuleScannerInput, productionRules: [ProductionRule]) {
        self.productionRules = productionRules
        self.input = input
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        let lastRuleId = productionRules.count - 1
        
        var nodes = [ParseTreeNode]()
        
        for (index, rule) in productionRules.enumerate() {
            let scanner = AnyProductionRuleScanner(rule: rule, input: input)
            
            switch scanner.scan(outputStream) {
            case .Fail:
                input.inputStream.resetPosition(position)
                return .Fail
            case .Nodes(let subnodes):
                nodes.appendContentsOf(subnodes)
            case .Success:
                // nothing to do
                break
            case .Terminal(let terminal):
                nodes.append(ParseTreeNode.Leaf(terminal))
            case .Tree(let tree):
                nodes.append(ParseTreeNode.Tree(tree))
            }
            
            if index != lastRuleId && input.ruleContext == .Parser {
                // For parsers check for delimiters between tokens
                let scanner = AnyProductionRuleScanner(rule: input.grammar.delimiter, input: input)
                let ignore = ProductionRuleScannerOutputStream()
                let _ = scanner.scan(ignore)
            }
        }
        
        return .Nodes(nodes)
    }
}

class VariantsProductionRuleScanner: ProductionRuleScanner {
    let productionRules: [ProductionRule]
    let input: ProductionRuleScannerInput
    
    init(input: ProductionRuleScannerInput, productionRules: [ProductionRule]) {
        self.productionRules = productionRules
        self.input = input
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        for rule in productionRules {
            
            let scanner = AnyProductionRuleScanner(rule: rule, input: input)
            let result = scanner.scan(outputStream)
            switch result {
            case .Fail:
                input.inputStream.resetPosition(position)
                continue
            default:
                return result
            }
        }
        
        input.inputStream.resetPosition(position)
        return .Fail
    }
}

class CheckProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    let checkFunction: ProductionRuleCheckFunction
    
    init(input: ProductionRuleScannerInput, checkFunction: ProductionRuleCheckFunction) {
        self.input = input
        self.checkFunction = checkFunction
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        if checkFunction() {
            return .Success
        } else {
            input.inputStream.resetPosition(position)
            return .Fail
        }
    }
}

class TerminalProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    let terminal: String
    
    init(input: ProductionRuleScannerInput, terminal: String) {
        self.input = input
        self.terminal = terminal
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        let position = input.inputStream.position()
        
        for character in terminal.characters {
            let streamCharacter = input.inputStream.getCharacter()
            input.inputStream.moveNext()
            
            if character != streamCharacter {
                input.inputStream.resetPosition(position)
                return .Fail
            }
        }
        return .Terminal(terminal)
    }
}

class CharRangesProductionRuleScanner: ProductionRuleScanner {
    let input: ProductionRuleScannerInput
    let positive: Bool
    let ranges: [CharRange]
    
    init(input: ProductionRuleScannerInput, positive: Bool, ranges: [CharRange]) {
        self.input = input
        self.positive = positive
        self.ranges = ranges
    }
    
    func scan(outputStream: ProductionRuleScannerOutputStream) -> ParserResult {
        if let streamCharacter = input.inputStream.getCharacter() {
            if positive {
                for range in ranges {
                    if range.contains(streamCharacter) {
                        input.inputStream.moveNext()
                        return .Terminal(String(streamCharacter))
                    }
                }
                return .Fail
            } else {
                for range in ranges {
                    if range.contains(streamCharacter) {
                        return .Fail
                    }
                }
                input.inputStream.moveNext()
                return .Terminal(String(streamCharacter))
            }
        } else {
            return .Fail
        }
    }
}

//case Check(() -> ())
//case CharRanges(Bool, [CharRange])
//case Reference(RuleName)
//case Compound([ProductionRule])
//case Or([ProductionRule])
//case Optional(ProductionRule)
//case StringRule(String) // rename to Terminal
//case Multiple(UInt, ProductionRule)
//case Empty
//case Eof

class LexicalAnalyzer {
    func analyze(string: String, grammar: Grammar, firstRule: RuleName) -> LexicalAnalysisResult {
        if let rule = grammar.rules.rules[firstRule] {
            let input = ProductionRuleScannerInput(
                inputStream: InputStringStream(string: string),
                grammar: grammar,
                ruleContext: grammar.contextCheckFunction(firstRule)
            )
            let scanner = AnyProductionRuleScanner(rule: rule, input: input)
            let outputStream = ProductionRuleScannerOutputStream()
            return scanner.scan(outputStream)
        }
        
        return .Fail
    }
}