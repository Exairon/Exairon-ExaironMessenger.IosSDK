//
//  MessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 31.01.2023.
//

import SwiftUI

struct MessageView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings
    
    var body: some View {
        switch message.messageType {
        case "text":
            TextMessageView(message: message, widgetSettings: widgetSettings)
        default:
            Text("Unsupported Message")
        }
    }
    
    init(message: Message, widgetSettings: WidgetSettings) {
        self.message = message
        self.widgetSettings = widgetSettings
    }
    
}
