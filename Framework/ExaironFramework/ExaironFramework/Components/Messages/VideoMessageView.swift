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

    var body: some View {
        HStack {
            switch message.attachment?.payload?.videoType {
            case "local":
                LocalVideoMessageView(src: message.attachment?.payload?.src ?? "")
            default:
                Text("Unsupported Video Type")
            }
            Spacer()
        }
            .padding(.horizontal, 16)
    }
    
    init(message: Message) {
        self.message = message
    }
}
