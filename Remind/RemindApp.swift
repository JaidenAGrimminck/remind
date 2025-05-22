//
//  RemindApp.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/3/25.
//

import SwiftUI
import AppKit

@main
struct RemindApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        Window("", id: "overlay") {
            OverlayRootView()
                .frame(width: OverlayRootView._w, height: OverlayRootView._h)
                .ignoresSafeArea()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        // make it off screen
        .defaultPosition(.topLeading)
        
//        Window("", id: "arrow") {
//            ChevronView()
//                .frame(width: ChevronView._w, height: ChevronView._h)
//                .ignoresSafeArea()
//        }
//        .windowResizability(.contentSize)
//        .windowStyle(.hiddenTitleBar)
//        .defaultPosition(.topLeading)
    }
}
