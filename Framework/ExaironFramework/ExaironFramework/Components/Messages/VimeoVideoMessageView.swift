//
//  VimeoVideoMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 6.02.2023.
//

import SwiftUI
import WebKit

struct VimeoView: UIViewRepresentable {
    let src: String
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let demoURL = URL(string: src) else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: demoURL))
    }
}

struct VimeoVideoMessageView: View {
    @State var src: String
    
    var body: some View {
        VimeoView(src: src)
            .frame(width: 300, height: 300)
            .padding()
    }}
