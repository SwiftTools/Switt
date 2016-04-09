public protocol Init {
    var attributes: Attributes? { get }
    var declarationModifiers: [DeclarationModifier] { get }
    var parameters: [Parameter] { get }
    var throwing: Throwing? { get }
    var unwrapping: Unwrapping? { get }
    var code: CodeBlock { get }
}