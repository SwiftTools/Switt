//
// Copyright (c) 2016 Switt contributors
// This program is made available under the terms of the MIT License.
//

import SwiftFelisCatus

class SourceKitAccessibilityConverter {
    func accessibility(accessibility: SourceKitAccessibility) -> Accessibility {
        switch accessibility {
        case .Public:
            return .Public
        case .Internal:
            return .Internal
        case .Private:
            return .Private
        }
    }
}