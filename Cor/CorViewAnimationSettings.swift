//
//  CorViewAnimationSettings.swift
//  Cor
//
//  Created by Whittlesey, Skyler on 2/10/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation

public enum CorViewAnimationEntryType {
    case slideLeft, slideRight, slideUp, fade
}

public struct CorViewAnimationSettings {
    
    var entryType: CorViewAnimationEntryType
    var entryDuration: TimeInterval
    var viewDuration: TimeInterval
    var dismissDuration: TimeInterval
    
    static var defaultSettings: CorViewAnimationSettings {
        return CorViewAnimationSettings(entryType: .slideUp, entryDuration: 0.5, viewDuration: 3.0, dismissDuration: 0.5)
    }
}
