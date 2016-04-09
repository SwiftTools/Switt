//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public protocol Parameter {
    var externalName: String? { get }
    var localName: String { get }
    var type: String { get }
}
