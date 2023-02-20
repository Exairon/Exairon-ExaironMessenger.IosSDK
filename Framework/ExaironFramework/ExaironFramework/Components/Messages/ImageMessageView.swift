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
        HStack {
            if message.sender.contains("user_uttered") {
                Spacer()
            }
            AsyncImage(url: URL(string: message.attachment?.payload?.src ?? "")!,
                           placeholder: { ProgressView() },
                           image: { Image(uiImage: $0).resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
            if message.sender.contains("bot_uttered") {
                Spacer()
            }
        }
    }
}
