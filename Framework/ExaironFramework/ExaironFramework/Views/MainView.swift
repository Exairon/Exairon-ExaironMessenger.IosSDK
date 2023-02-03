//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit

public struct MainView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    @State private var avatarUrl: String? = nil
    @State private var loading = true
    @State private var widgetColor: WidgetColor? = nil
    @State private var message: WidgetMessage? = nil

    public var body: some View {
        if(!loading) {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: avatarUrl ?? ""),
                                   content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 40, maxHeight: 40)
                        },
                                   placeholder: {
                            ProgressView()
                        })
                        .padding(.trailing, 15)
                        VStack(alignment: .leading) {
                            Text(message?.headerTitle ?? "Chat")
                                .bold()
                                .foregroundColor(Color(hex: widgetColor?.headerFontColor ?? "000000"))
                                .font(.system(size: 26))
                            Text(message?.headerMessage ?? "Chat")
                                .foregroundColor(Color(hex: widgetColor?.headerFontColor ?? "000000"))
                        }
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 30))
                            .foregroundColor(Color(hex: widgetColor?.headerFontColor ?? "000000"))
                    }
                    .padding()
                    .background(Color(hex: widgetColor?.headerColor ?? "FFFFFF"))
                    
                    ScrollView {
                        ForEach(chatViewModel.messageArray, id: \.self) { message in
                            MessageView(message: message, widgetSettings: chatViewModel.widgetSettings!)
                        }.rotationEffect(.degrees(180))
                    }.rotationEffect(.degrees(180))
                    
                    HStack {
                        TextField(message?.placeholder ?? "Type a message",
                                  text: $chatViewModel.messageText)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onSubmit {
                            chatViewModel.sendMessage(message: chatViewModel.messageText)
                        }
                        Spacer()
                        Button {
                            chatViewModel.sendMessage(message: chatViewModel.messageText)
                        } label: {
                            Image(systemName: "arrow.up.circle.fill").font(.system(size: 40))
                        }
                        .font(.system(size: 26))
                        .padding(.horizontal, 10)
                    }
                    .padding()
                }
                .frame(
                   minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .topLeading
               )
             
        } else {
            ProgressView().onAppear(perform: getWidgetSettings)
        }
    }
    
    private func getWidgetSettings(){
        chatViewModel.readMessage()
        chatViewModel.getWidgetSettings(){result in
            if(result.status == "success") {
                self.avatarUrl = Exairon.shared.src + "/uploads/channels/" + result.data.avatar
                self.widgetColor = result.data.color
                for _message in result.data.messages {
                    if(_message.lang == Exairon.shared.language) {
                        message = _message
                    }
                }
                if (message == nil) {
                    message = result.data.messages[0]
                }
                loading = false
            }
            else {
                print("errorr")
            }
        }
    }
    
   
    
    public init() {}

}
