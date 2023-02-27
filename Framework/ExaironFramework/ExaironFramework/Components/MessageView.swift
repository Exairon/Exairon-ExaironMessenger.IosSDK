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
                ImageMessageView(message: message, chatViewModel: chatViewModel, viewRouter: viewRouter)
            case "button":
                ButtonMessageView(message: message, widgetSettings: widgetSettings, chatViewModel: chatViewModel)
            case "video":
                VideoMessageView(message: message, widgetSettings: widgetSettings)
            case "audio":
                AudioMessageView(message: message, chatViewModel: chatViewModel)
            case "document":
                DocumentMessageView(message: message, widgetSettings: widgetSettings)
            case "carousel":
                CarouselMessageView(message: message, widgetSettings: widgetSettings, chatViewModel: chatViewModel)
            case "location":
                LocationMessageView(message: message)
            case "survey":
                SurveyView(message: message, widgetSettings: widgetSettings, chatViewModel: chatViewModel, viewRouter: viewRouter)
            default:
                Text("Unsupported Message")
                    .font(.custom(widgetSettings.data.font, size: 18))
            }
            MessageTimeView(message: message, widgetSettings: widgetSettings)
        }
    }    
}
