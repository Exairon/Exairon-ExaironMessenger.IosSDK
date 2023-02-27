//
//  ChatSenderView.swift
//  ExaironFramework
//
//  Created by Exairon on 27.02.2023.
//

import SwiftUI

struct ChatSenderView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        if chatViewModel.showInputArea {
            HStack {
                if chatViewModel.widgetSettings?.data.showAttachments == true {
                    Button {
                        chatViewModel.showingCredits.toggle()
                    } label: {
                        Image(systemName: "plus").font(.system(size: 30))
                    }
                        .font(.system(size: 26))
                        .padding(.horizontal, 10)
                        .sheet(isPresented: $chatViewModel.showingCredits) {
                            if #available(iOS 16.0, *) {
                                BottomSheetView(chatViewModel: chatViewModel)
                                    .presentationDetents([.height(250)])
                            } else {
                                BottomSheetView(chatViewModel: chatViewModel)
                                    .frame(height: 250)
                            }
                        }
                }
                TextField(chatViewModel.message?.placeholder ?? "Type a message",
                          text: $chatViewModel.messageText)
                    .padding()
                    .background(Color(hex: "#1E1E1E10"))
                    .cornerRadius(10)
                Button {
                    if chatViewModel.messageText.count > 0 {
                        chatViewModel.sendMessage(message: chatViewModel.messageText)
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill").font(.system(size: 40))
                }
                    .font(.system(size: 26))
                    .padding(.horizontal, 10)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .onDisappear {
                if chatViewModel.widgetSettings?.data.showSurvey == false {
                    chatViewModel.changePage(page: .splashView, viewRouter: viewRouter)
                    self.mode.wrappedValue.dismiss()
                }
            }
        } else {
            EmptyView()
        }
    }
}
