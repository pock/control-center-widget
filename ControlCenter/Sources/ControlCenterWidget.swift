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
    
    /// Core
    // Use controlsRaw to find volume and brightness items. Using control will show same icon for both vol(and brightness) up and down in slideableController when only 1 of up/down is enabled
    private lazy var controlsRaw: [ControlCenterItem] = {
        return [
            CCSleepItem(parentWidget: self),
            CCLockItem(parentWidget: self),
            CCScreensaverItem(parentWidget: self),
            CCDoNotDisturbItem(parentWidget: self),
            CCBrightnessDownItem(parentWidget: self),
            CCBrightnessUpItem(parentWidget: self),
            CCBrightnessToggleItem(parentWidget: self),
            CCVolumeDownItem(parentWidget: self),
            CCVolumeUpItem(parentWidget: self),
            CCVolumeToggleItem(parentWidget: self),
            CCVolumeMuteItem(parentWidget: self)
        ]
    }()
    
    private var controls: [ControlCenterItem] {
        return controlsRaw.filter({ $0.enabled })
    }
    
    private var slideableController: PKSlideableController?
    
    /// Volume items
    public var volumeItems: [ControlCenterItem] {
        return controlsRaw.filter({ $0 is CCVolumeUpItem || $0 is CCVolumeDownItem || $0 is CCVolumeMuteItem || $0 is CCVolumeToggleItem })
    }
    
    /// Brightness items
    public var brightnessItems: [ControlCenterItem] {
        return controlsRaw.filter({ $0 is CCBrightnessUpItem || $0 is CCBrightnessDownItem })
    }
    
    /// UI
    fileprivate var segmentedControl: PressableSegmentedControl!
    
    required init() {
        self.load()
    }
    
    func viewDidAppear() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: .shouldReloadControlCenterWidget, object: nil, queue: .main, using: { [weak self] _ in
            self?.load()
        })
    }
    
    private func load() {
        self.initializeSegmentedControl()
        self.view = segmentedControl
    }
    
    private func initializeSegmentedControl() {
        let items = controls.map({ $0.icon }) as [NSImage]
        guard segmentedControl == nil else {
            segmentedControl.segmentCount = controls.count
            items.enumerated().forEach({ index, item in
                segmentedControl.setImage(item, forSegment: index)
                segmentedControl.setWidth(50, forSegment: index)
            })
            return
        }
        segmentedControl = PressableSegmentedControl(images: items, trackingMode: .selectOne, target: self, action: #selector(tap(_:)))
        segmentedControl.delegate = self
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.autoresizingMask = .width
        controls.enumerated().forEach({ index, _ in
            segmentedControl.setWidth(50, forSegment: index)
        })
        segmentedControl.didPressAt = { [unowned self] location in
            self.longTap(at: location)
        }
    }
    
    private func tap(at location : CGPoint) {
        let index = Int(ceil(location.x / (segmentedControl.frame.width / CGFloat(controls.count)))) - 1
        guard (0..<controls.count).contains(index) else { return }
        segmentedControl.selectedSegment = index
        controls[index].action()
    }
    
    @objc private func tap(_ sender: NSSegmentedControl) {
        controls[sender.selectedSegment].action()
    }
    
    // Hard Coded integer causes issue on long tap area when number of items change
    @objc private func longTap(at location: CGPoint) {
        let index = Int(ceil(location.x / (segmentedControl.frame.width / CGFloat(controls.count)))) - 1
        guard (0..<controls.count).contains(index) else { return }
        segmentedControl.selectedSegment = index
        controls[index].longPressAction()
    }
}

extension ControlCenterWidget {
    func showSlideableController(for item: ControlCenterItem?, currentValue: Float = 0) {
        guard let item = item else { return }
        slideableController = PKSlideableController.load()
        switch item.self {
        case is CCVolumeUpItem, is CCVolumeDownItem, is CCVolumeMuteItem, is CCVolumeToggleItem:
            slideableController?.set(
                downItem: controlsRaw.first(where: { $0 is CCVolumeDownItem }),
                upItem: controlsRaw.first(where: { $0 is CCVolumeUpItem })
            )
        case is CCBrightnessUpItem, is CCBrightnessDownItem, is CCBrightnessToggleItem:
            slideableController?.set(
                downItem: controlsRaw.first(where: { $0 is CCBrightnessDownItem }),
                upItem: controlsRaw.first(where: { $0 is CCBrightnessUpItem })
            )
        default:
            return
        }
        slideableController?.set(currentValue: currentValue)
        slideableController?.pushOnMainNavigationController()
    }
}

extension ControlCenterWidget: PressableSegmentedControlDelegate {
    func didMove(with event: NSEvent, location: NSPoint) {
        let slider = slideableController?.touchBar?.item(forIdentifier: NSTouchBarItem.Identifier(rawValue: "SlideItem"))
        slider?.view?.touchesBegan(with: event)
        slider?.view?.touchesMoved(with: event)
        slideableController?.set(initialLocation: location)
    }
}

extension ControlCenterWidget: PKScreenEdgeMouseDelegate{
    
    func screenEdgeController(_ controller: PKScreenEdgeController, mouseEnteredAtLocation location: NSPoint, in view: NSView) {
        let location = view.convert(location, to: segmentedControl)
        let index = Int(ceil(location.x / (segmentedControl.frame.width / CGFloat(controls.count)))) - 1
        guard (0..<controls.count).contains(index),
              segmentedControl.bounds.contains(location)
        else {
            if segmentedControl.selectedSegment != -1 { segmentedControl.selectedSegment = -1 }
            return
        }
        if segmentedControl.selectedSegment != index { segmentedControl.selectedSegment = index }
    }
    
    func screenEdgeController(_ controller: PKScreenEdgeController, mouseMovedAtLocation location: NSPoint, in view: NSView) {
        let location = view.convert(location, to: segmentedControl)
        let index = Int(ceil(location.x / (segmentedControl.frame.width / CGFloat(controls.count)))) - 1
        guard (0..<controls.count).contains(index),
              segmentedControl.bounds.contains(location)
        else {
            if segmentedControl.selectedSegment != -1 { segmentedControl.selectedSegment = -1 }
            return
        }
        if segmentedControl.selectedSegment != index { segmentedControl.selectedSegment = index }
    }
    
    func screenEdgeController(_ controller: PKScreenEdgeController, mouseClickAtLocation location: NSPoint, in view: NSView) {
        let location = view.convert(location, to: segmentedControl)
        tap(at: location)
    }
    
    func screenEdgeController(_ controller: PKScreenEdgeController, mouseExitedAtLocation location: NSPoint, in view: NSView) {
        if segmentedControl.selectedSegment != -1 { segmentedControl.selectedSegment = -1 }
    }
}

