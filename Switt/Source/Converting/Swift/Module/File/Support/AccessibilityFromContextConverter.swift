//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftGrammar

protocol AccessibilityFromContextConverter {
    func convert(context: SwiftParser.Access_level_modifierContext?) -> Accessibility?
}

class AccessibilityFromContextConverterImpl: AccessibilityFromContextConverter {
    private let assembly: ConvertingAssembly
    
    init(assembly: ConvertingAssembly) {
        self.assembly = assembly
    }
    
    func convert(context: SwiftParser.Access_level_modifierContext?) -> Accessibility? {
        if let text = context?.getText() {
            switch text {
            case "private":
                return .Private
            case "public":
                return .Public
            case "internal":
                return .Internal
            default:
                return nil
            }
        } else {
            return .Internal
        }
    }
    
    //    func convert(context: SwiftParser.Access_level_modifierContext?) -> Accessibility? {
    //        if let text = context?.getText() {
    //            switch text {
    //            case "private(set)":
    //                return .Private
    //            case "public(set)":
    //                return .Public
    //            case "internal(set)":
    //                return .Internal
    //            }
    //        } else {
    //            return .Internal
    //        }
    //    }
}