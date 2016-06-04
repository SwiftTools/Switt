//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public protocol SwiftFile {
    var classes: [Class] { get }
    var structs: [Struct] { get }
    var protocols: [Protocol] { get }
    var enums: [Enum] { get }
}

struct SwiftFileData: SwiftFile {
    var classes: [Class]
    var structs: [Struct]
    var protocols: [Protocol]
    var enums: [Enum]
}