//
//  VideoPlayer.swift
//  ExaironFramework
//
//  Created by Exairon on 23.02.2023.
//
import AVKit
import SwiftUI

struct PlayerView: UIViewRepresentable {
    let player: AVPlayer

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
            playerController.player = player
            playerController.player?.play()
        }

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: player)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

}
