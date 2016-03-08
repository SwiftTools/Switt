//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

// Aka template argument in C++ world.
// E.g: <T: AnyObject>
public struct GenericPlaceholder {
    public var typeName: String // E.g: "T"
    public var constraints: [String] // E.g: ["AnyObject"]
}
