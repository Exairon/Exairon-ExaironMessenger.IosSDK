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
    
    func getDuration() -> Float {
        return Float(CMTimeGetSeconds((audioPlayer?.currentItem?.asset.duration) ?? CMTime(seconds: 0, preferredTimescale: 1)))
    }
}

struct AudioMessageView: View {
    @State var currentTime: Double = 0
    @State var currentDurationString: String = "0:00"
    @State var message: Message
    @State var chatViewModel: ChatViewModel
    @State var duration: Float = 0.00
    @State var durationString: String = "0:00"
    @State var song1 = false
    @StateObject private var soundManager = SoundManager()

    var body: some View {
        HStack {
            VStack{
                Image(systemName: song1 ? "pause.circle.fill": "play.circle.fill")
                    .font(.system(size: 25))
                    .padding(.trailing)
                    .onAppear {
                        soundManager.playSound(sound: message.custom?.data?.attachment?.payload?.src ?? "")
                        soundManager.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1), timescale: 2), queue: DispatchQueue.main) { progressTime in
                            currentTime = Double(progressTime.seconds)
                            if Int(currentTime) == Int(duration) {
                                song1 = false
                                soundManager.audioPlayer?.pause()
                                soundManager.audioPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
                            }
                            let durationMinutes = Int(currentTime / 60)
                            let durationSeconds = Int(currentTime) % 60 < 10 ? "0\(Int(currentTime) % 60)" : "\(Int(currentTime) % 60)"
                            currentDurationString = "\(durationMinutes):\(durationSeconds)"
                        }
                        duration = soundManager.getDuration()
                        let durationMinutes = Int(duration / 60)
                        let durationSeconds = Int(duration) % 60 < 10 ? "0\(Int(duration) % 60)" : "\(Int(duration) % 60)"
                        durationString = "\(durationMinutes):\(durationSeconds)"
                    }
                    .onTapGesture {
                        song1.toggle()
                        if song1 {
                            soundManager.audioPlayer?.play()
                        } else {
                            soundManager.audioPlayer?.pause()
                        }
                }
            }
            HStack {
                Text(currentDurationString).font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))
                Slider(value: $currentTime, in: 0...Double(Int(duration))) { didChange in
                    soundManager.audioPlayer?.seek(to: CMTime(seconds: currentTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
                }
                Text(durationString).font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
