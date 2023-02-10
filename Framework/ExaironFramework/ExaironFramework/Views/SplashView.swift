//
//  SplashView.swift
//  ExaironFramework
//
//  Created by Exairon on 3.02.2023.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @State private var scale = 1.0
    @State private var scaleSize = 0.05
    @State private var scaleUp = true
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        Image("exa_logo")
            .resizable()
            .frame(width: 150, height: 150)
            .scaleEffect(scale)
            .onReceive(timer) { input in
                scale += scaleSize
                if Double(round(100 * scale) / 100) == 2.0 {
                    scaleSize = -0.05
                } else if Double(round(100 * scale) / 100) == 1.0  {
                    scaleSize = 0.05
                }
            }
            .onAppear{
                chatViewModel.socketConnection { data in
                    chatViewModel.getWidgetSettings(){widgetSettings in }
                }
            }
    }
}
