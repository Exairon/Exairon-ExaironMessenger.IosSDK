//
//  TextView.swift
//  ExaironFramework
//
//  Created by Exairon on 31.01.2023.
//

import SwiftUI

struct TextMessageView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings
    
    var body: some View {
        if message.type.contains("user_uttered") {
            HStack {
                Spacer()
                Text(message.text ?? "")
                    .padding()
                    .foregroundColor(Color(hex: widgetSettings.data.color.userMessageFontColor))
                    .background(Color(hex: widgetSettings.data.color.userMessageBackColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        } else {
            HStack {
                Text(message.text ?? "")
                    .padding()
                    .foregroundColor(Color(hex: widgetSettings.data.color.botMessageFontColor))
                    .background(Color(hex: widgetSettings.data.color.botMessageBackColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                Spacer()
            }
        }
    }
    
    init(message: Message, widgetSettings: WidgetSettings) {
        self.message = message
        self.widgetSettings = widgetSettings
    }
}
