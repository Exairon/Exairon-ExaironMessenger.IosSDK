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
            AsyncImage(url: URL(string: chatViewModel.avatarUrl ?? "")!,
                           placeholder: { ProgressView() },
                           image: { Image(uiImage: $0).resizable() })
                   .aspectRatio(contentMode: .fit)
                   .frame(maxWidth: 40, maxHeight: 40)
                   .padding(.trailing, 15)
            VStack(alignment: .leading) {
                Text(chatViewModel.message?.headerTitle ?? "Chat")
                    .bold()
                    .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
                    .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 26))
                Text(chatViewModel.message?.headerMessage ?? "Chat")
                    .foregroundColor(Color(hex: chatViewModel.widgetSettings?.data.color.headerFontColor ?? "000000"))
                    .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))
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
                .alert(isPresented: $isPresentingConfirm) {
                    Alert(
                        title: Text(Localization.init().locale(key: "sessionFinishMessage"))
                            .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18)),
                        message: Text(""),
                        primaryButton: .destructive(Text(Localization.init().locale(key: "yes")), action: {
                            chatViewModel.finishSession()
                        }),
                        secondaryButton: .cancel(Text(Localization.init().locale(key: "cancel")), action: {
                            //isPresentingConfirm.toggle()
                        })
                    )
                }.padding()

            }
        }
            .padding()
            .background(Color(hex: chatViewModel.widgetSettings?.data.color.headerColor ?? "#FFFFFF"))
    }
}
