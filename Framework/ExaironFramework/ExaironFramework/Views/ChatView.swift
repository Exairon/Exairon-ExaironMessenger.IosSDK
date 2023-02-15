//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @StateObject var viewRouter: ViewRouter
    @State private var showingCredits = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            HeaderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            Spacer()
            ScrollView {
                ForEach(chatViewModel.messageArray, id: \.self) { message in
                    MessageView(message: message, widgetSettings: chatViewModel.widgetSettings!, chatViewModel: chatViewModel, viewRouter: viewRouter)
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            
            HStack {
                Image("exa_logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("We Run Exairon")
                    .font(.system(size: 15))
            }
            .padding(0)
            
            if chatViewModel.showInputArea {
                HStack {
                    Button {
                        showingCredits.toggle()
                    } label: {
                        Image(systemName: "plus").font(.system(size: 40))
                    }
                        .font(.system(size: 26))
                        .padding(.horizontal, 10)
                        .sheet(isPresented: $showingCredits) {
                            if #available(iOS 16.0, *) {
                                BottomSheetView()
                                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.3)])
                            } else {
                                BottomSheetView()
                            }
                        }
                    TextField(chatViewModel.message?.placeholder ?? "Type a message",
                              text: $chatViewModel.messageText)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onSubmit {
                            if chatViewModel.messageText.count > 0 {
                                chatViewModel.sendMessage(message: chatViewModel.messageText)
                            }
                        }
                    Spacer()
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
            }
        }
        .onAppear{
            chatViewModel.initializeChatView()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}
