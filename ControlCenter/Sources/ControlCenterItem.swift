//
//  ControlCenterItem.swift
//  ControlCenter
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation
import PockKit

class ControlCenterItem {
    
    weak var parentWidget: ControlCenterWidget?
    
    var enabled: Bool {
        get {
            return false
        }
    }
    
    init(parentWidget: ControlCenterWidget?) {
        self.parentWidget = parentWidget
    }
    
    var title: String {
        get {
            fatalError("Property `title` must be override in subclasses.")
        }
    }
    
    var icon: NSImage {
        get {
            let bundle = Bundle(for: ControlCenterWidget.self)
            return bundle.image(forResource: title) ?? NSImage(named: NSImage.statusUnavailableName)!
        }
    }
    
    @discardableResult
    func action() -> Any? {
        fatalError("Function `action()` must be override in subclasses.")
    }
    
    func longPressAction() {
        /* Function `longPressAction()` can be override in subclasses. */
    }
    
    func didSlide(at value: Double) {
        /* Function `didSlide(at:Double)` can be override in subclasses. */
    }
}
