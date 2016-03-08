//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

struct PropertyDeclaration {
    var name: String
    
    var getter: FunctionAccessorGetterDeclaration?
    var setter: FunctionAccessorSetterDeclaration?
    var didSet: FunctionAccessorDidsetDeclaration?
    var willSet: FunctionAccessorWillsetDeclaration?
    var address: FunctionAccessorAddressDeclaration?
    var mutableAddress: FunctionAccessorMutableaddressDeclaration?
}