//
//  CarouselCardView.swift
//  ExaironFramework
//
//  Created by Exairon on 2.02.2023.
//

import SwiftUI

struct CarouselCardView: View {
    @State var element: Element
    @State var widgetColor: WidgetColor
    @State var chatViewModel: ChatViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: element.image_url ?? "")!,
                           placeholder: { ProgressView() },
                           image: { Image(uiImage: $0).resizable() })
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    .padding(10)
                    .border(Color.black, width: 2)
                    .cornerRadius(5)
            Text(element.title ?? "")
                .font(.custom("OpenSans", size: 26))
                .bold()
                .padding()
            Text(element.subtitle ?? "").font(.custom("OpenSans", size: 18))
            VStack {
                ForEach(element.buttons ?? [], id: \.self) {button in
                    LargeButton(title:  AnyView(Text(button.title ?? "").font(.custom("OpenSans", size: 18))),
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
