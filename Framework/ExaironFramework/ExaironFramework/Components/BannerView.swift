//
//  Banner.swift
//  ExaironFramework
//
//  Created by Exairon on 27.02.2023.
//

import SwiftUI
import URLImage

struct Banner: View {
    @ObservedObject var chatViewModel: ChatViewModel

    var body: some View {
        if chatViewModel.widgetSettings?.data.whiteLabelWidget == false {
            HStack {
                URLImage(url: URL(string: "\(Exairon.shared.src)/assets/images/logo-sm.png")!,
                empty: {
                    Text("Nothing here")
                 },
                inProgress: { progress -> CustomSpinner in
                    CustomSpinner(frameSize: 20)
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
                        .frame(width: 20, height: 20)
                })
                Text("We run on Exairon")
                    .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 15))
            }
            .padding(0)
        } else {
            EmptyView()
        }
    }
}
