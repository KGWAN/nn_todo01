//
//  oliiTodoWidgetLiveActivity.swift
//  oliiTodoWidget
//
//  Created by JUNGGWAN KIM on 4/13/26.
//
//  실시간으로 변하는 정보를 잠금 화면 하단이나 다이내믹 아일랜드(Dynamic Island)에 고정해서 보여주는 기능
//

import ActivityKit
import WidgetKit
import SwiftUI

struct oliiTodoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct oliiTodoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: oliiTodoWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension oliiTodoWidgetAttributes {
    fileprivate static var preview: oliiTodoWidgetAttributes {
        oliiTodoWidgetAttributes(name: "World")
    }
}

extension oliiTodoWidgetAttributes.ContentState {
    fileprivate static var smiley: oliiTodoWidgetAttributes.ContentState {
        oliiTodoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: oliiTodoWidgetAttributes.ContentState {
         oliiTodoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: oliiTodoWidgetAttributes.preview) {
   oliiTodoWidgetLiveActivity()
} contentStates: {
    oliiTodoWidgetAttributes.ContentState.smiley
    oliiTodoWidgetAttributes.ContentState.starEyes
}
