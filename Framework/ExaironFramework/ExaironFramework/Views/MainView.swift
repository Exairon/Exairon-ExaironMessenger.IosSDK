//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit
import BackgroundTasks

@available(iOS 14.0, *)
public struct MainView: View {
    @StateObject var viewRouter = ViewRouter()
    @ObservedObject var chatViewModel = ChatViewModel()
    @Environment(\.scenePhase) var phase
    
    public var body: some View {
        ZStack {
            switch viewRouter.currentPage {
            case .splashView:
                SplashView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            case .formView:
                FormView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            case .chatView:
                ChatView(chatViewModel: chatViewModel, viewRouter: viewRouter)
            }
        }.onChange(of: phase) { newPhase in
            print("enes")
            switch newPhase {
            case .background: scheduleAppRefresh()
            default: break
            }
        }.navigationBarHidden(true)
    }
            
    func scheduleAppRefresh() {
        if viewRouter.currentPage == .chatView {
            chatViewModel.initializeChatView()
        }
    }
    
    public init() {}
}
