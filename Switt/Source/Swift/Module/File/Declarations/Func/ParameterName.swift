// It looks like optional, but in this enum both cases represent something specific
public enum ParameterName {
    case None // "_"
    case Some(String) // any identifier, e.g.: "a"
}