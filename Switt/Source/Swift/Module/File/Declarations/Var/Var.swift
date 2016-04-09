//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public protocol Var {
    var name: String { get }
    var type: Type { get }
    var accessibility: Accessibility { get }
}
