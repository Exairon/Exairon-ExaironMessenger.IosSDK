//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI
import URLImage

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                HStack {
                    Button{
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                            Text(Localization.init().locale(key: "back"))
                                .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 20))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
               
                HeaderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            } else {
                HeaderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            }
            
            MessageListContainerView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            Banner(chatViewModel: chatViewModel)
            ChatSenderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            
        }
        .onAppear{
            chatViewModel.initializeChatView()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}
