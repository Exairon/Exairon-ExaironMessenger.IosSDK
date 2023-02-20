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
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                HStack {
                    Button{
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                            Text(Localization.init().locale(key: "back"))
                                .font(.custom("OpenSans", size: 20))
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
               
                HeaderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            } else {
                HeaderView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            }
            ScrollView {
                ScrollViewReader { scrollView in
                    ForEach(chatViewModel.messageArray, id: \.self) { message in
                        MessageView(message: message, widgetSettings: chatViewModel.widgetSettings!, chatViewModel:     chatViewModel, viewRouter: viewRouter)
                    }
                    .onChange(of: chatViewModel.messageArray) { messages in
                        scrollView.scrollTo(messages[messages.endIndex - 1])
                    }
                    .rotationEffect(.degrees(180))
                }
            }.rotationEffect(.degrees(180))
            
            HStack {
                Image("exa_logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("We run on Exairon")
                    .font(.custom("OpenSans", size: 15))
            }
            .padding(0)
            
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
                              text: $chatViewModel.messageText, onCommit: {
                        if chatViewModel.messageText.count > 0 {
                            chatViewModel.sendMessage(message: chatViewModel.messageText)
                            chatViewModel.messageText = ""
                        }
                    })
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
