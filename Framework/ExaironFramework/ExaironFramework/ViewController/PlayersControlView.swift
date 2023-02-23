//
//  PlayersControlView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.02.2023.
//

import SwiftUI
import AVKit

struct PlayerControlsView : View {
  @State var playerPaused = true
  @State var seekPos = 0.0
  let player: AVPlayer
  var body: some View {
      HStack {
          Button(action: {
            self.playerPaused.toggle()
            if self.playerPaused {
              self.player.pause()
            }
            else {
              self.player.play()
            }
          }) {
            Image(systemName: playerPaused ? "play" : "pause")
              .padding(.leading, 20)
              .padding(.trailing, 20)
          }
          Slider(value: $seekPos, in: 0...1, onEditingChanged: { _ in
              guard let item = self.player.currentItem else {
                    return
              }
         
              let targetTime = self.seekPos * item.duration.seconds
              self.player.seek(to: CMTime(seconds: targetTime, preferredTimescale: 600))
          })
            .padding(.trailing, 20)
        }
    }
    
    init(player: AVPlayer) {
        self.player = player
    }
}
