//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit

public struct MainView: View {
    @ObservedObject var chatViewModel = ChatViewModel()

    public var body: some View {
        ZStack {
            switch chatViewModel.viewRouter.currentPage {
            case .splashView:
                SplashView(chatViewModel: chatViewModel)
            case .formView:
                FormView(chatViewModel: chatViewModel)
            case .chatView:
                ChatView(chatViewModel: chatViewModel)
            }
        }
    }
    
    public init() {}

}
