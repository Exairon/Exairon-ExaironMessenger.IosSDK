//
//  ChatView.swift
//  ExaironFramework
//
//  Created by Exairon on 23.01.2023.
//

import SwiftUI
import AVKit

public struct ChatView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    
    public var body: some View {
        VStack {
            HStack {
                Text(Exairon.shared.src)
            }
            .background(.blue)
            HStack {
                Text(Exairon.shared.channelId)
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
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
       )
    }
    
    public init() {}
}
