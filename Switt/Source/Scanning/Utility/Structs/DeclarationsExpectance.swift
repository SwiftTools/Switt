//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import Foundation

class DeclarationExpectance {
    var inits = false
    var deinits = false
    
    // Methods
    var instanceMethods = false
    var classMethods = false
    var staticMethods = false
    
    // Types
    var classes = false
    var structs = false
    var typealiases = false
    
    // Vars
    var staticVars = false
    var instanceVars = false
    var parameters = false
}