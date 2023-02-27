//
//  MessageListContainerView.swift
//  ExaironFramework
//
//  Created by Exairon on 27.02.2023.
//

import SwiftUI

struct MessageListContainerView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        ScrollView {
            if #available(iOS 14.0, *) {
                ScrollViewReader { scrollView in
                    ForEach(chatViewModel.messageArray, id: \.self) { message in
                        if message.ruleMessage == false || message.ruleMessage == nil {
                            MessageView(message: message, widgetSettings: chatViewModel.widgetSettings!, chatViewModel: chatViewModel, viewRouter: viewRouter)
                        } else {
                            EmptyView()
                        }
                    }
                    .onChange(of: chatViewModel.messageArray) { messages in
                        if messages.count > 0 {
                            scrollView.scrollTo(messages[messages.endIndex - 1])
                        }
                    }
                    .rotationEffect(.degrees(180))
                }
            } else {
                ForEach(chatViewModel.messageArray, id: \.self) { message in
                    if message.ruleMessage == false || message.ruleMessage == nil {
                        MessageView(message: message, widgetSettings: chatViewModel.widgetSettings!, chatViewModel: chatViewModel, viewRouter: viewRouter)
                    } else {
                        EmptyView()
                    }
                }
                .rotationEffect(.degrees(180))
            }
        }.rotationEffect(.degrees(180))
    }
}
