//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

protocol SwiftFile {
    var classes: [Class] { get }
    var structs: [Struct] { get }
    var protocols: [Protocol] { get }
    var enums: [Enum] { get }
}