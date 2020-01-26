//
//  Preferences.swift
//  ControlCenter
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation
import Defaults

extension NSNotification.Name {
    static let shouldReloadControlCenterWidget = NSNotification.Name("shouldReloadControlCenterWidget")
}

extension Defaults.Keys {
    static let shouldShowSleepItem            = Defaults.Key<Bool>("shouldShowSleepItem",            default: false)
    static let shouldShowLockItem             = Defaults.Key<Bool>("shouldShowLockItem",             default: false)
    static let shouldShowScreensaverItem      = Defaults.Key<Bool>("shouldShowScreensaverItem",      default: false)
    static let shouldShowDoNotDisturbItem     = Defaults.Key<Bool>("shouldShowDoNotDisturbItem",     default: false)
    static let isDoNotDisturb                 = Defaults.Key<Bool>("isEnabledDoNotDisturb",          default: false)
    static let shouldShowBrightnessItem       = Defaults.Key<Bool>("shouldShowBrightnessItem",       default: true)
    static let shouldShowVolumeItem           = Defaults.Key<Bool>("shouldShowVolumeItem",           default: true)
    static let shouldShowBrightnessDownItem   = Defaults.Key<Bool>("shouldShowBrightnessDownItem",   default: true)
    static let shouldShowBrightnessUpItem     = Defaults.Key<Bool>("shouldShowBrightnessUpItem",     default: true)
    static let shouldShowBrightnessToggleItem = Defaults.Key<Bool>("shouldShowBrightnessToggleItem", default: false)
    static let shouldShowVolumeDownItem       = Defaults.Key<Bool>("shouldShowVolumeDownItem",       default: true)
    static let shouldShowVolumeUpItem         = Defaults.Key<Bool>("shouldShowVolumeUpItem",         default: true)
    static let shouldShowVolumeMuteItem       = Defaults.Key<Bool>("shouldShowVolumeMuteItem",       default: false)
    static let isVolumeMute                   = Defaults.Key<Bool>("isVolumeMute",                   default: false)
    static let shouldShowVolumeToggleItem     = Defaults.Key<Bool>("shouldShowVolumeToggleItem",     default: false)
}
