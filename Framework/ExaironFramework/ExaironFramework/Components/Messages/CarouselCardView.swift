//
//  CarouselCardView.swift
//  ExaironFramework
//
//  Created by Exairon on 2.02.2023.
//

import SwiftUI
import URLImage

struct CarouselCardView: View {
    @State var element: Element
    @State var widgetColor: WidgetColor
    @State var chatViewModel: ChatViewModel
    
    var body: some View {
        VStack {
            URLImage(url: URL(string: element.image_url ?? "")!,
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
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    .padding(10)
                    .border(Color.black, width: 2)
                    .cornerRadius(5)
            })
            Text(element.title ?? "")
                .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 26))
                .bold()
                .padding()
            Text(element.subtitle ?? "").font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))
            VStack {
                ForEach(element.buttons ?? [], id: \.self) {button in
                    LargeButton(title:  AnyView(Text(button.title ?? "").font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 18))),
                        backgroundColor: Color(hex: widgetColor.buttonBackColor) ?? Color.black,
                        foregroundColor: Color(hex: widgetColor.buttonFontColor) ?? Color.white)  {
                            if button.type == "postback" {
                                chatViewModel.sendMessage(message: button.title ?? "", payload: button.payload)
                            }
                        }
                }
            }
        }
        .padding()
    }
}
