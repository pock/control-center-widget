//
//  ControlCenterWidget.swift
//  ControlCenter
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit
import PockKit

class ControlCenterWidget: PKWidget {
    
    var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier(rawValue: "ControlCenterWidget")
    var customizationLabel: String = "ControlCenter"
    var view: NSView!
    
    required init() {
        self.view = PKButton(title: "ControlCenter", target: self, action: #selector(printMessage))
    }
    
    @objc private func printMessage() {
        NSLog("[ControlCenterWidget]: Hello, World!")
    }
    
}
