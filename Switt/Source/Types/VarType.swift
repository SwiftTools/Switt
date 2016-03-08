//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public enum VarType {
    case Strict(VarTypeInfo)
    case Inferred(VarTypeInferenceInfo)
    case Unknown([VarTypeInferenceError])
}