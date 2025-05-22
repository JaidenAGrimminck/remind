//
//  WindowCoordinator.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/22/25.
//

import SwiftUI
import AppKit


final class WindowCoordinator: ObservableObject {
    weak var panel: NSWindow!
    weak var tab: NSWindow!
    @Published var isOpen = false
    
    func toggle() {
        guard let screen = panel.screen ?? NSScreen.main else { return }
        
        let closedX = screen.frame.maxX - OverlayRootView.visibleTab
        let openX = screen.frame.maxX - panel.frame.width - OverlayRootView.rightMargin
        

        let tabClosedX = closedX - tab.frame.width + OverlayRootView.visibleTab
        let tabOpenX = screen.frame.maxX - panel.frame.width - (tab.frame.width * 1.5) + 2
        
        let targetX = isOpen ? closedX : openX
        let tabTargetX = isOpen ? tabClosedX : tabOpenX
        
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.25
            
            panel.setFrameOrigin(.init(x: targetX, y: panel.frame.minY))
            tab.setFrameOrigin(.init(x: tabTargetX, y: tab.frame.minY))
        }
        
        isOpen.toggle()
        
    }
}
