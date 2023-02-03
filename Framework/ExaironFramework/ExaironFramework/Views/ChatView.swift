//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: chatViewModel.avatarUrl ?? ""),
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
                    Text(chatViewModel.message?.headerTitle ?? "Chat")
                        .bold()
                        .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
                        .font(.system(size: 26))
                    Text(chatViewModel.message?.headerMessage ?? "Chat")
                        .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
                }
                Spacer()
                Image(systemName: "xmark.circle")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
            }
            .padding()
            .background(Color(hex: chatViewModel.widgetSettings?.data.color.headerColor ?? "FFFFFF"))
            
            ScrollView {
                ForEach(chatViewModel.messageArray, id: \.self) { message in
                    MessageView(message: message, widgetSettings: chatViewModel.widgetSettings!)
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            
            HStack {
                TextField(chatViewModel.message?.placeholder ?? "Type a message",
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
    }
}
