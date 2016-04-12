//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public protocol Func {
    var name: String { get }
    var accessibility: Accessibility { get }
    var parameters: [Parameter] { get }
    var returnType: Type { get }
}

struct FuncData: Func {
    var name: String
    var accessibility: Accessibility
    var parameters: [Parameter]
    var returnType: Type
}