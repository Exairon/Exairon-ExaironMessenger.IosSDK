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
    @State var chatViewModel: ChatViewModel
    @State var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            switch message.type {
            case "text":
                TextMessageView(message: message, widgetSettings: widgetSettings)
            case "image":
                ImageMessageView(message: message)
            case "button":
                ButtonMessageView(message: message, widgetSettings: widgetSettings, chatViewModel: chatViewModel)
            case "video":
                VideoMessageView(message: message)
            case "audio":
                AudioMessageView(message: message)
            case "document":
                DocumentMessageView(message: message)
            case "carousel":
                CarouselMessageView(message: message, widgetSettings: widgetSettings, chatViewModel: chatViewModel)
            case "location":
                LocationMessageView(message: message)
            case "survey":
                SurveyView(message: message, widgetSettings: widgetSettings, chatViewModel: chatViewModel, viewRouter: viewRouter)
            default:
                Text("Unsupported Message")
            }
            MessageTimeView(message: message)
        }
    }    
}
