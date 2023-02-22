//
//  VideoMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import AVKit

struct VideoMessageView: View {
    @State var message: Message
    @State var widgetSettings: WidgetSettings

    var body: some View {
        HStack {
            switch message.attachment?.payload?.videoType {
            case "local":
                LocalVideoMessageView(src: message.attachment?.payload?.src ?? "")
            case "youtube":
                YoutubeVideoMessageView(src: message.attachment?.payload?.src ?? "")
            case "vimeo":
                VimeoVideoMessageView(src: message.attachment?.payload?.src ?? "")
            default:
                Text("Unsupported Video Type").font(.custom(widgetSettings.data.font, size: 18))
            }
            Spacer()
        }
            .padding(.horizontal, 16)
    }
}
