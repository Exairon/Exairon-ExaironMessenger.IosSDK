//
//  ColorSelectorView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit

public struct ColorSelectorView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    let channelId: String
    
    public var body: some View {
        HStack {
            Text(Exairon.shared.channelId ?? "nil")
            Button(action: {
                chatViewModel.getWidgetSettings(){result in
                    if(result.status == "success") {
                        print(result.data.color.botMessageBackColor)
                    }
                    else {
                        print("errorr")
                    }
                }
            }) {
                Image("chat")
                .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original)).resizable()
                .frame(width: 32.0, height: 32.0)
            }
        }
    }
    
    public init(_channelId: String) {
        channelId = _channelId
    }
}
