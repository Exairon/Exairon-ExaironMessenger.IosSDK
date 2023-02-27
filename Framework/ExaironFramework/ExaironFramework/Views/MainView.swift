//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit

public struct MainView: View {
    @StateObject var viewRouter = ViewRouter()
    @ObservedObject var chatViewModel = ChatViewModel()
    
    public var body: some View {
        ZStack {
            switch viewRouter.currentPage {
            case .splashView:
                SplashView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            case .formView:
                FormView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            case .chatView:
                ChatView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            case .imageView:
                ImageView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            }
        }.navigationBarHidden(true)
        .onAppCameToForeground {
            scheduleAppRefresh()
        }
    }
            
    func scheduleAppRefresh() {
        if viewRouter.currentPage == .chatView {
            chatViewModel.initializeChatView()
        }
    }
    
    public init() {}
}
