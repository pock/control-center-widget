//
//  ControlCenterVolumeUpItem.swift
//  Pock
//
//  Created by Pierluigi Galdi on 16/02/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation
import Defaults

class CCVolumeUpItem: ControlCenterItem {
    
    override var enabled: Bool { return Defaults[.shouldShowVolumeItem] && Defaults[.shouldShowVolumeUpItem] }
    
    private let key: KeySender = KeySender(keyCode: NX_KEYTYPE_SOUND_UP, isAux: true)
    
    override var title: String { return "volume-up" }
    
    override var icon:  NSImage { return NSImage(named: NSImage.touchBarVolumeUpTemplateName)! }
    
	private var valueCorrected: Float = 0
	
    override func action() -> Any? {
        Defaults[.isVolumeMute] = false
        key.send()
        NSWorkspace.shared.notificationCenter.post(name: .shouldReloadControlCenterWidget, object: nil)
        return NSSound.systemVolume()
    }
    
    override func longPressAction() {
        parentWidget?.showSlideableController(for: self, currentValue: valueCorrected)
    }
    
    override func didSlide(at value: Double) {
		/// I've noticed that if you try to quickly flick the slider to the left to mute the volume, it often doesn't go all the way
		/// to the left which makes the volume really low, but not muted.
		/// This part fixes this behaviour by muting the volume when the slider is almost fully to the left.
		if value < 0.07 {
			valueCorrected = 0
			NSSound.setSystemVolume(0.01)
			Defaults[.isVolumeMute] = true
		}else {
			valueCorrected = Float(value)
			NSSound.setSystemVolume(valueCorrected)
			Defaults[.isVolumeMute] = false
		}
        NSWorkspace.shared.notificationCenter.post(name: .shouldReloadControlCenterWidget, object: nil)
    }
    
}
