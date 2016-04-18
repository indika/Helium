//
//  UserSettings.swift
//  Helium
//
//  Created by Christian Hoffmann on 10/31/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Foundation

internal enum UserSetting {
    case DisabledMagicURLs
    case DisabledFullScreenFloat
    case OpacityPercentage

    var userDefaultsKey: String {
        switch self {
        case .DisabledMagicURLs: return "disabledMagicURLs"
        case .DisabledFullScreenFloat: return "disabledFullScreenFloat"
        case .OpacityPercentage: return "opacityPercentage"
        }
    }
}
