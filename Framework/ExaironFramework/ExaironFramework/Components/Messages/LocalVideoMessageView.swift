//
//  LocalVideoMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import AVKit

struct LocalVideoMessageView: View {
    @State var src: String
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: URL(string: src)!))
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
            .cornerRadius(10)
    }
}
