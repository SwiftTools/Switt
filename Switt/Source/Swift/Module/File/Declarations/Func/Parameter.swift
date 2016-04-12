//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

public protocol Parameter {
    var externalName: ParameterName? { get }
    var localName: ParameterName { get }
    var type: TypeAnnotation { get }
}

struct ParameterData: Parameter {
    var externalName: ParameterName?
    var localName: ParameterName
    var type: TypeAnnotation
}