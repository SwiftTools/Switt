//
// Copyright (c) 2016 Swick contributors
// This program is made available under the terms of the MIT License.
//

struct UnwrappingError: ErrorType {
}

extension Optional {
    // throws UnwrappingException
    func unwrap() throws -> Wrapped {
        if let unwrapped = self {
            return unwrapped
        } else {
            throw UnwrappingError()
        }
    }
}