//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

// TODO: this is designed to be used as a property of variable, its type, for type inference
// SourceKit doesn't type inference. However, at the moment it doesn't work. And if it worked, there
// will be a cyclic reference to a... struct, which is impossible.
// TODO: remove it and invent other way for type inference.
public enum DeclarationTreeNode {
    case Class(ClassDeclaration)
    case Struct(StructDeclaration)
    case Protocol(ProtocolDeclaration)
}