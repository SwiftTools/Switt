enum RawDeclarationModifier {
    case Access(RawAccessLevelModifier)
    case Other(RawDeclarationModifierOther)
}

enum RawDeclarationModifierOther: String {
    case Class = "class"
    case Convenience = "convenience"
    case Dynamic = "dynamic"
    case Final = "final"
    case Infix = "infix"
    case Lazy = "lazy"
    case Mutating = "mutating"
    case Nonmutating = "nonmutating"
    case Optional = "optional"
    case Override = "override"
    case Postfix = "postfix"
    case Prefix = "prefix"
    case Required = "required"
    case Static = "static"
    case Unowned = "unowned"
    case UnownedSafe = "unowned(safe)"
    case UnownedUnsafe = "unowned(unsafe)"
    case Weak = "weak"
}