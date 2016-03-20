enum ParserResult {
    case Fail
    case Success
    case Nodes([SyntaxTree])
    case Tree(SyntaxTree)
}