//
//  ButtonMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI

struct ButtonMessageView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings
    @State var chatViewModel: ChatViewModel
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text(message.text ?? "")
                    .padding()
                    .foregroundColor(Color(hex: widgetSettings.data.color.botMessageFontColor))
                    .background(Color(hex: widgetSettings.data.color.botMessageBackColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                Spacer()
            }
            WrappingHStack() {
                ForEach(message.quick_replies ?? [], id: \.self) {quickReply in
                    LargeButton(title: AnyView(Text(quickReply.title ?? "")),
                                 backgroundColor: Color(hex: widgetSettings.data.color.buttonBackColor) ?? Color.black,
                                 foregroundColor: Color(hex: widgetSettings.data.color.buttonFontColor) ?? Color.white) {
                                     if quickReply.type == "postback" {
                                         chatViewModel.sendMessage(message: quickReply.title ?? "", payload: quickReply.payload)
                                     } else {
                                         if let url = URL(string: quickReply.url ?? "") {
                                             UIApplication.shared.open(url)
                                         }
                                     }
                                 }
                }
            }
            .padding()
            /*ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(message.quick_replies ?? [], id: \.self) { in quickReply
                        LargeButton(title: AnyView(Text(quickReply.title ?? "")),
                            backgroundColor: Color(hex: widgetSettings.data.color.buttonBackColor) ?? Color.black,
                            foregroundColor: Color(hex: widgetSettings.data.color.buttonFontColor) ?? Color.white) {
                                if quickReply.type == "postback" {
                                    chatViewModel.sendMessage(message: quickReply.title ?? "", payload: quickReply.payload)
                                }
                            }
                    }
                }.padding(.horizontal)
            }.frame(height: 56)*/
        }
        
    }
}
