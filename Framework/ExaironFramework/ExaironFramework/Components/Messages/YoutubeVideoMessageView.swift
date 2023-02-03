//
//  YoutubeVideoMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import WebKit

struct YouTubeView: UIViewRepresentable {
    let videoId: String
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: "https://www.youtube.com/watch?v=\(videoId)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}

struct YoutubeVideoMessageView: View {
    @State var videoId: String
    
    var body: some View {
        YouTubeView(videoId: videoId)
            .frame(width: 300, height: 300)
            .padding()
    }
    
    init(src: String) {
        let array = src.components(separatedBy: "/")
        self.videoId = array[array.count - 1]
    }
}
