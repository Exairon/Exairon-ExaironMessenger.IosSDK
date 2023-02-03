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
        if(!chatViewModel.loading) {
            ZStack {
                ChatView(chatViewModel: chatViewModel)
            }
        } else {
            ProgressView().onAppear{
                chatViewModel.getWidgetSettings(){widgetSettings in }
            }
        }
    }
    
    public init() {}

}
