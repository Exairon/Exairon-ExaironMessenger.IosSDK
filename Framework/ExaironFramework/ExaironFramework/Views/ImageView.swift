//
//  ImageView.swift
//  ExaironFramework
//
//  Created by Exairon on 25.02.2023.
//

import SwiftUI
import URLImage

struct ImageView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                URLImage(url: URL(string: chatViewModel.fullScreenImageUrl ?? "")!,
                empty: {
                    Text("Nothing here")
                 },
                inProgress: { progress -> CustomSpinner in
                    CustomSpinner(frameSize: 90)
                },
                failure: { error, retry in
                    VStack {
                        Text(error.localizedDescription)
                        Button("Retry", action: retry)
                    }
                },
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width)
                        .clipShape(Rectangle())
                        .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                })
            }
            VStack {
                HStack {
                    Button{
                        viewRouter.currentPage = .chatView
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 30))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
