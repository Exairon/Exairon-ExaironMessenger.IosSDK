//
//  HeaderView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var chatViewModel: ChatViewModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: chatViewModel.avatarUrl ?? ""),
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
                Text(chatViewModel.message?.headerTitle ?? "Chat")
                    .bold()
                    .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
                    .font(.system(size: 26))
                Text(chatViewModel.message?.headerMessage ?? "Chat")
                    .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
            }
            Spacer()
            Image(systemName: "xmark.circle")
                .font(.system(size: 30))
                .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
        }
        .padding()
        .background(Color(hex: chatViewModel.widgetSettings?.data.color.headerColor ?? "FFFFFF"))
    }
}
