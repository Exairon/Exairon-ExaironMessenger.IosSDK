//
//  TextView.swift
//  ExaironFramework
//
//  Created by Exairon on 31.01.2023.
//

import SwiftUI
import WebKit

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct TextMessageView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings
    
    var body: some View {
        if message.sender.contains("user_uttered") {
            HStack {
                Spacer()
                Text(htmlStringToSwiftString(text: message.text?.replacingOccurrences(of: "&lt;", with: "<") ?? ""))
                    .padding()
                    .font(.custom(widgetSettings.data.font, size: 18))
                    .foregroundColor(Color(hex: widgetSettings.data.color.userMessageFontColor))
                    .background(Color(hex: widgetSettings.data.color.userMessageBackColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
            }
        } else {
            HStack {
                Text(htmlStringToSwiftString(text: message.text?.replacingOccurrences(of: "&lt;", with: "<") ?? ""))
                    .padding()
                    .font(.custom(widgetSettings.data.font, size: 18))
                    .foregroundColor(Color(hex: widgetSettings.data.color.botMessageFontColor))
                    .background(Color(hex: widgetSettings.data.color.botMessageBackColor))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                Spacer()
            }
        }
        /*Text("Regular")
        Text("*Italics*")
        Text("**Bold**")
        Text("~Strikethrough~")
        Text("`Code`")
        Text("[Link](https://apple.com)")
        Text("***[They](https://apple.com) ~are~ `combinable`***")*/
        
    }
    
    func htmlStringToSwiftString(text: String) -> String {
        //var swiftString = text.replacingOccurrences(of: "<i>", with: "*").replacingOccurrences(of: "</i>", with: "*")
        //swiftString = swiftString.replacingOccurrences(of: "<strong>", with: "**").replacingOccurrences(of: "</strong>", with: "**")
        //swiftString = swiftString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
