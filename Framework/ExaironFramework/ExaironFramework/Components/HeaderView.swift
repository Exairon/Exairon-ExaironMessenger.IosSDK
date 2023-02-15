//
//  HeaderView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @StateObject var viewRouter: ViewRouter
    @State private var isPresentingConfirm: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        HStack {
            if #unavailable(iOS 16.0) {
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(.white)
                }
            }
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
            if viewRouter.currentPage == .chatView {
                Button {
                    isPresentingConfirm = true
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
                }
                .confirmationDialog(Localization.init().locale(key: "sessionFinishMessage"),
                    isPresented: $isPresentingConfirm) {
                    Button(Localization.init().locale(key: "yes"), role: .destructive) {
                        chatViewModel.finishSession()
                    }
                    } message: {
                        Text(Localization.init().locale(key: "sessionFinishMessage"))
                    }
            }
        }
            .padding()
            .background(Color(hex: chatViewModel.widgetSettings?.data.color.headerColor ?? "#FFFFFF"))
    }
}
