//
//  ButtonMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import WrappingHStack

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
                    .font(.custom(widgetSettings.data.font, size: 18))
                    .foregroundColor(Color(hex: widgetSettings.data.color.botMessageFontColor))
                    .background(Color(hex: widgetSettings.data.color.botMessageBackColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                Spacer()
            }
            WrappingHStack {
                WrappingHStack(message.quick_replies ?? [], id:\.self) {
                    let quickReply = $0
                    LargeButton(title: AnyView(Text(quickReply.title ?? "").font(.custom(widgetSettings.data.font, size: 18))),
                        backgroundColor: Color(hex: widgetSettings.data.color.buttonBackColor) ?? Color.black,
                        foregroundColor: Color(hex: widgetSettings.data.color.buttonFontColor) ?? Color.white) {
                            if quickReply.type == "postback" {
                                chatViewModel.sendMessage(message: quickReply.title ?? "", payload: quickReply.payload)
                            }
                        }
                }.frame(minWidth: 250)
            }
            .padding()
        }
        
    }
}
