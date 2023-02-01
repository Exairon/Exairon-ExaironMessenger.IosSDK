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
            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                ForEach(message.quick_replies ?? [], id: \.self) { quickReply in
                    LargeButton(title: quickReply.title ?? "",
                                backgroundColor: Color(hex: widgetSettings.data.color.buttonBackColor) ?? Color.black,
                                foregroundColor: Color(hex: widgetSettings.data.color.buttonFontColor) ?? Color.white) {
                                            print("Hello World")
                                        }
                }
            }
        }
        
    }
    
    init(message: Message, widgetSettings: WidgetSettings) {
        self.message = message
        self.widgetSettings = widgetSettings
    }
}
