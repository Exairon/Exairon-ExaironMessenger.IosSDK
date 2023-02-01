//
//  AudioMessage.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import AVKit

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }

}

struct AudioMessageView: View {
    @State var message: Message
    @State var song1 = false
    @StateObject private var soundManager = SoundManager()
    
    var body: some View {
        HStack {
            VStack{
                Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
                    .font(.system(size: 25))
                    .padding(.trailing)
                    .onTapGesture {
                        soundManager.playSound(sound: message.custom?.data?.attachment?.payload?.src ?? "")
                        song1.toggle()
                        
                        if song1{
                            soundManager.audioPlayer?.play()
                        } else {
                            soundManager.audioPlayer?.pause()
                        }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    init(message: Message) {
        self.message = message
    }
}
