//
//  OverlayRootView.swift
//  Remind
//
//  Created by Jaiden Grimminck on 5/3/25.
//
import SwiftUI
import AppKit

struct Event: Identifiable {
    enum Kind { case exam, todo, event, assignment }
    let id = UUID()
    let kind: Kind
    let title: String
    let date: Date
    let location: String?
    let priority: Int // 1 = highest priority, 2 = lower
}

extension Array where Element == Event {
    // jank for now, fix w/ api call
    static func mock() -> [Event] {
        [
            .init(kind: .todo, title: "Senior Exit Form",
                  date: ISO8601DateFormatter().date(from: "2025-05-28T23:59:00Z")!,
                  location: nil, priority: 2),
            .init(kind: .event, title: "Senior Night",
                  date: ISO8601DateFormatter().date(from: "2025-06-04T18:00:00Z")!,
                  location: "School", priority: 2),
            .init(kind: .event, title: "Graduation",
                  date: ISO8601DateFormatter().date(from: "2025-06-06T12:00:00Z")!,
                  location: "School", priority: 2)
        ]
    }
}

struct OverlayRootView: View {
    static var _w = CGFloat(280);
    static var _h = CGFloat(420);
    static var visibleTab: CGFloat = 24
    
    static var topMargin: CGFloat = 10
    static var rightMargin: CGFloat = 10
    
    static var bgColor = Color(red: 33/255, green: 33/255, blue: 33/255)
    
    @State public var isOpen = false
    
    // replace w/ @StateObject later
    @State private var events = [Event].mock()
    
    // live countdown
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .leading) {
            mainCard
            // Chevron tab
            chevron
                .offset(x: isOpen ? 260 : 0)    // follows the card
        }
        .onReceive(timer) { now = $0 }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension OverlayRootView {
    var nextEvent: Event? { events.sorted {$0.date < $1.date}.first }
    
    func toggleWindow() {
        guard
            let window = NSApp.windows.first,
            let screen = window.screen ?? NSScreen.main
        else { return }
        
        let closedX = screen.frame.maxX - OverlayRootView.visibleTab
        let openX = screen.frame.maxX - window.frame.width - OverlayRootView.rightMargin
        
        let targetX = isOpen ? closedX : openX
        
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.25
            window.setFrameOrigin(NSPoint(x: targetX, y: window.frame.origin.y))
        }
        
        isOpen.toggle()
    }
    
    
    var mainCard: some View {
        // Main dark card
        VStack(alignment: .leading, spacing: 12) {
            header
            Divider().background(Color.white.opacity(0.2))
            list
            Spacer(minLength: 6)
            seeMoreView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(OverlayRootView.bgColor)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1))
        .shadow(radius: 0)
        // Slide in/out
        .offset(x: isOpen ? 0 : OverlayRootView._w - OverlayRootView.visibleTab)       // width (280) - visible tab (20)
        .animation(.easeInOut(duration: 0.25), value: !isOpen)
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: 0) {
//            if let next = nextEvent {
//                Text(timeLeft(to: next.date))
//                        .font(.system(size: 28, weight: .bold, design: .monospaced))
//
//                Text("left")
//                    .foregroundStyle(.secondary)
//                    .font(.system(size: 12, weight: .bold, design: .monospaced))
//                    .padding(.bottom, 2)
//
//                Text("Next:")
//                    .font(.subheadline).foregroundStyle(.secondary)
//                Text(next.title)
//                    .font(.subheadline.bold())
//            } else {
//                Text("No upcoming items.")
//                    .font(.subheadline)
//            }
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text("12:12:12")
                        .font(.system(size: 24))
                    
                    Text("left")
                        .font(.system(size: 12))
                }
                .padding(.bottom, 6)
                
                Text("Next:")
                    .font(.system(size: 10))
                
                Text("Snooze and Sleep!")
                    .font(.system(size: 12))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack {
                    Text("n")
                        .font(.system(size: 10, weight: .bold))
                    Text(" exams")
                        .font(.system(size: 10))
                }.padding(.bottom, 2)
                HStack {
                    Text("n")
                        .font(.system(size: 10, weight: .bold))
                    Text(" assignments")
                        .font(.system(size: 10))
                }.padding(.bottom, 2)
                HStack {
                    Text("n")
                        .font(.system(size: 10, weight: .bold))
                    Text(" todos")
                        .font(.system(size: 10))
                }.padding(.bottom, 2)
                HStack {
                    Text("n")
                        .font(.system(size: 10, weight: .bold))
                    Text(" events")
                        .font(.system(size: 10))
                }
            }
        }
        .foregroundColor(.white)
        .padding([.top], 5)
        .padding([.trailing, .leading], 10)
    }
    
    var list: some View {
        ForEach(events) { event in
            VStack {
                HStack(alignment: .top, spacing: 8) {
                    icon(for: event.kind)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(kindLabel(for: event.kind))
                            .font(.caption2.smallCaps())
                            .foregroundStyle(.gray)
                        Text(event.title)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(event.date, style: .date)
                        + Text(", ")
                        + Text(event.date, style: .time)
                        if let loc = event.location {
                            Text("\(loc)").foregroundStyle(.secondary)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .foregroundColor(.white)
                .padding([.bottom, .leading, .trailing], 5)
                
                Divider().background(Color.white.opacity(0.2))
            }
        }
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
    
     
    
    var seeMoreView: some View {
        
        // fix me :(((
        VStack {
            Button( action: { self.seeMore() }) {
                Text("")
                    .font(.system(size: 12, weight: .bold))
                    .frame(width: 40, height: 15)
                    .border(.clear)
                    .background(OverlayRootView.bgColor)
            }
            .buttonStyle(.plain)
            
        }.frame(width: 50, height: 15, alignment: .center)
    }
    
    
    func seeMore() {
        // todo
    }

    // helper funcs
    func timeLeft(to target: Date) -> String {
       let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: target)
       return String(format: "%02d:%02d:%02d",
                     (components.day ?? 0) * 24 + (components.hour ?? 0),
                     components.minute ?? 0,
                     components.second ?? 0)
    }

    func icon(for kind: Event.Kind) -> some View {
       let name: String
       switch kind {
       case .exam: name = "pencil.circle.fill"
       case .todo: name = "square.and.pencil.circle.fill"
       case .assignment: name = "square.and.pencil.circle.fill"
       case .event: name = "party.popper.fill"
       }
       return Image(systemName: name)
           .frame(width: 40, height: 40, alignment: .center)
           .foregroundStyle(.yellow)
           .font(.title2)
    }

    func kindLabel(for kind: Event.Kind) -> String {
       switch kind {
       case .exam:  return "Exams"
       case .todo:  return "TODO"
       case .event: return "Events"
       case .assignment: return "Assignment"
       }
    }
}
