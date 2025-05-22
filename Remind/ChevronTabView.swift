//
//  ChevronView.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/22/25.
//

import SwiftUI

struct ChevronTabView: View {
    @EnvironmentObject private var coord: WindowCoordinator
    
    var body: some View {
        Button(action: coord.toggle) {
            Image(systemName: coord.isOpen
                               ? "chevron.compact.left"
                               : "chevron.compact.right")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(NSColor(OverlayRootView.bgColor).withAlphaComponent(coord.isOpen ? 1 : 0.8)))
                .clipShape(
                    .rect(
                        topLeadingRadius: 8,
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    )
                )
        }
        .buttonStyle(.plain)
        .frame(width: 20, height: 60)               // tab window’s whole size
    }
}
