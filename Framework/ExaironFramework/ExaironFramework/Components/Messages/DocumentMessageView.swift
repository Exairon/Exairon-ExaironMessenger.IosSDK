//
//  DocumentMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import Foundation

struct DocumentMessageView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings
    
    var body: some View {
        HStack {
            if message.sender.contains("user_uttered") {
                Spacer()
            }
            Button(action: downloadFile) {
                HStack {
                    Image(systemName: "doc.fill")
                    Text(message.custom?.data?.attachment?.payload?.originalname ?? "empty")
                        .font(.custom(widgetSettings.data.font, size: 18))
                }
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: "#1E1E1E"))
                .cornerRadius(10)
            }
            if !message.sender.contains("user_uttered") {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
    
    func downloadFile() {
        DispatchQueue.main.async {
            if let url = URL(string: message.custom?.data?.attachment?.payload?.src ?? "") {
                UIApplication.shared.open(url)
            }
        }
    }
}
