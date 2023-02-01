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
        VStack {
            switch message.messageType {
            case "text":
                TextMessageView(message: message, widgetSettings: widgetSettings)
            case "image":
                ImageMessageView(message: message)
            case "button":
                ButtonMessageView(message: message, widgetSettings: widgetSettings)
            case "video":
                VideoMessageView(message: message)
            case "audio":
                AudioMessage(message: message)
            default:
                Text("Unsupported Message")
            }
            MessageTimeView(message: message)
        }
    }
    
    init(message: Message, widgetSettings: WidgetSettings) {
        self.message = message
        self.widgetSettings = widgetSettings
    }
    
}
