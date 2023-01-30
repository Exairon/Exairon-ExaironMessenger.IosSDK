//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit

public struct ChatView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    @State private var avatarUrl: String? = nil

    public var body: some View {
        switch (chatViewModel.widgetSettings?.status){
            case "success":
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
                            Text(chatViewModel.widgetSettings?.data.messages[0].headerTitle ?? "Chat")
                                .bold()
                                .foregroundColor(Color(hex: "007AFF"))
                                .font(.system(size: 26))
                            Text(chatViewModel.widgetSettings?.data.messages[0].headerMessage ?? "Chat")
                        }
                        Spacer()
                        Image(systemName: "xmark.circle").font(.system(size: 30))
                    }
                    
                    ScrollView {
                        ForEach(chatViewModel.messages, id: \.self) { message in
                            if message.contains("[USER]") {
                                let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                                HStack {
                                    Spacer()
                                    Text(newMessage)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(.gray.opacity(0.16))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 10)
                                }
                            } else {
                                HStack {
                                    Text(message)
                                        .padding()
                                        .background(.gray.opacity(0.15))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 10)
                                    Spacer()
                                }
                            }
                        }.rotationEffect(.degrees(180))
                    }.rotationEffect(.degrees(180))
                    
                    HStack {
                        TextField("Type something", text: $chatViewModel.messageText)
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
                .padding()
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
               )
            case nil:
                ProgressView().onAppear(perform: getWidgetSettings)
            default:
                Text("error")
        }
        
    }
    
    private func getWidgetSettings(){
        chatViewModel.getWidgetSettings(){result in
            if(result.status == "success") {
                print(result.data.color.botMessageBackColor)
                self.avatarUrl = Exairon.shared.src + "/uploads/channels/" + result.data.avatar
            }
            else {
                print("errorr")
            }
        }
    }
    
    public init() {}
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

