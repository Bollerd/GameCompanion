//
//  Date.swift
//  gameCompanion
//
//  Created by Dirk Boller on 31.07.23.
//  Copyright © 2023 Dirk Boller. All rights reserved.
//

import Foundation

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
