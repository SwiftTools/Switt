//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

// E.g.: <T: AnyObject, U: CollectionType where T.Generator.Element == Int>
public struct GenericPlaceholders {
    public var placeholders: [GenericPlaceholder] // E.g.: T: AnyObject and U: CollectionType
    public var whereClause: String? // E.g.: "T.Generator.Element == Int"
    
    public init(placeholders: [GenericPlaceholder], whereClause: String?) {
        self.placeholders = placeholders
        self.whereClause = whereClause
    }
}
