public protocol ProtocolInit {
    var attributes: Attributes? { get }
    var declarationModifiers: [DeclarationModifier] { get }
    var parameters: [Parameter] { get }
    var throwing: Throwing? { get }
    var unwrapping: Unwrapping? { get }
}

struct ProtocolInitData: ProtocolInit {
    var attributes: Attributes?
    var declarationModifiers: [DeclarationModifier]
    var parameters: [Parameter]
    var throwing: Throwing?
    var unwrapping: Unwrapping?
}