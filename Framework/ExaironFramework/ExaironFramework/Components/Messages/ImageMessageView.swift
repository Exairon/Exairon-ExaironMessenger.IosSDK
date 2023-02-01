//
//  ImageMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI

struct ImageMessageView: View {
    @State var message: Message

    var body: some View {
        //AsyncImage(url: URL(string: message.attachment?.payload?.src ?? ""),
        HStack {
            if (message.type.contains("user_uttered")) {
                Spacer()
            }
            AsyncImage(url: URL(string: "https://test.services.exairon.com/uploads/chat/chat-1675236396606-screenshot_1667311544.png"),
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    .cornerRadius(10)
            },
                placeholder: {
                    ProgressView()
            })
                .padding(.horizontal, 16)
            if (message.type.contains("bot_uttered")) {
                Spacer()
            }
        }
    }
    
    init(message: Message) {
        self.message = message
    }
}
