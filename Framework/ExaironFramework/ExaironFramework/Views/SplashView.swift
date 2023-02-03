//
//  SplashView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    
    var body: some View {
        ProgressView().onAppear{
            chatViewModel.getWidgetSettings(){widgetSettings in }
        }
    }
}
