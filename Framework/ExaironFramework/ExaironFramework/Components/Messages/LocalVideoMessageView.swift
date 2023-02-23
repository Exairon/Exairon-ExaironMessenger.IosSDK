//
//  LocalVideoMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import AVKit

struct LocalVideoMessageView: View {
    @State var player: AVPlayer
    var body: some View {
        VStack {
            PlayerView(player: player)
            PlayerControlsView(player: player)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
        .cornerRadius(10)
    }
    
    init(src: String) {
        self.player = AVPlayer(url: URL(string: src)!)
    }
}
