//
//  ImageMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import URLImage

struct ImageMessageView: View {
    @State var message: Message

    var body: some View {
        HStack {
            if message.sender.contains("user_uttered") {
                Spacer()
            }
            URLImage(url: URL(string: message.attachment?.payload?.src ?? "")!,
            empty: {
                Text("Nothing here")
             },
            inProgress: { progress -> CustomSpinner in
                CustomSpinner(frameSize: 90)
            },
            failure: { error, retry in
                VStack {
                    Text(error.localizedDescription)
                    Button("Retry", action: retry)
                }
            },
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
            })
            if message.sender.contains("bot_uttered") {
                Spacer()
            }
        }
    }
}
