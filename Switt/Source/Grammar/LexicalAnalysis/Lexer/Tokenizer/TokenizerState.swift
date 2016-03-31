enum TokenizerState {
    case Possible
    case Complete
    case Fail
    case FatalError // TODO: Maybe to use exception instead of this
}