//
//  ChevronView.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/22/25.
//

import SwiftUI

public struct ChevronView: View {
    static var _w = CGFloat(20);
    static var _h = CGFloat(60);
    
    @State var isOpen: Bool = false
    
    public var body: some View {
        VStack(alignment: .leading) {
            chevron
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(OverlayRootView.bgColor)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1))
        .shadow(radius: 0)
        // animation in/out
        .offset(x: isOpen ? 0 : OverlayRootView._w - OverlayRootView.visibleTab)
        .animation(.easeInOut(duration: 0.25), value: !isOpen)
    }
    
    func toggleWindow() {
        debugPrint("toggleWindow called")
        isOpen.toggle()
    }
    
    var chevron: some View {
        Button(action: { self.toggleWindow() }) {
               Image(systemName: isOpen ? "chevron.compact.left" : "chevron.compact.right")
                   .font(.system(size: 26, weight: .bold))
                   .foregroundColor(.white.opacity(0.9))
                   .frame(width: 20, height: 60)   // small visible sliver
                   .background(Color(NSColor.windowBackgroundColor.withAlphaComponent(0.6)))
                   .clipShape(RoundedRectangle(cornerRadius: !isOpen ? 8 : 0, style: .continuous))
           }
           .buttonStyle(.plain)
       }
}
