//
//  Functions.swift
//  gameCompanion
//
//  Created by Dirk Boller on 08.09.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import Foundation

let DEBUG_PRINT_OPTION = false


/// wrapper for the build in print function - printing is disabled/enabled by boolean variable
/// - Parameter text: text to be printted
func debug_print(_ text: String) {
    if DEBUG_PRINT_OPTION {
        print(text)
    }
}
