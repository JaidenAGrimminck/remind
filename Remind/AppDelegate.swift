//
//  AppDelegate.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/3/25.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let win = NSApp.windows.first else { return }
        
        NSApp.activate(ignoringOtherApps: true)
        
        window = win
        
        win.titleVisibility = .hidden
        win.isOpaque = false
        win.backgroundColor = .clear
        win.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        win.level = .floating
        win.standardWindowButton(.zoomButton)?.isHidden = true
        win.standardWindowButton(.miniaturizeButton)?.isHidden = true
        win.standardWindowButton(.closeButton)?.isHidden = true
        win.orderFrontRegardless()
        
        if let screen = win.screen ?? NSScreen.main {
            let x = screen.frame.maxX - OverlayRootView.visibleTab
            
            let y = screen.frame.maxY - CGFloat(490) - OverlayRootView.topMargin
            win.setFrameOrigin(NSPoint(x: x, y: y))
        }

    }
}
