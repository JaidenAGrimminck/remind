//
//  AppDelegate.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/3/25.
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    let coordinator = WindowCoordinator()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let panel = NSApp.windows.first,
              let screen = panel.screen ?? NSScreen.main
        else { return }
        
        coordinator.panel = panel
        
        NSApp.activate(ignoringOtherApps: true)
                
        panel.titleVisibility = .hidden
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.level = .floating
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.closeButton)?.isHidden = true
        panel.orderFrontRegardless()
        panel.styleMask = [.borderless]
        
        // tab window
        let tabSize = NSSize(width: 20, height: 60)
        let tabRect = NSRect(origin: .zero, size: tabSize)
        let tab = NSWindow(contentRect: tabRect, styleMask: .borderless, backing: .buffered, defer: false)
        coordinator.tab = tab
        
        tab.isOpaque           = false
        tab.backgroundColor    = .clear
        tab.level              = .floating
        tab.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        tab.ignoresMouseEvents = false        // we *do* want clicks
        tab.titlebarAppearsTransparent = true
        
        
        // chevron
        let chevron = ChevronTabView().environmentObject(coordinator)
        tab.contentView = NSHostingView(rootView: chevron)
        tab.setContentSize(tabSize)
        
        // close windows (off screen)
        let closedX = screen.frame.maxX - OverlayRootView.visibleTab
        
        let y = screen.frame.maxY - 490 - OverlayRootView.topMargin
        
        panel.setFrameOrigin(.init(x: closedX, y: y))
        tab.setFrameOrigin(.init(x: closedX - tabSize.width + OverlayRootView.visibleTab, y: y + panel.frame.height - tab.frame.height + 1))
        
        tab.makeKeyAndOrderFront(nil)
    }
}
