//
//  CarouselCardView.swift
//  ExaironFramework
//
//  Created by Exairon on 2.02.2023.
//

import SwiftUI

struct CarouselCardView: View {
    var element: Element
    var widgetColor: WidgetColor
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: element.image_url ?? ""),
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                    .padding(10)
                    .border(Color.black, width: 2)
                    .cornerRadius(5)
                    
            },
                placeholder: {
                    ProgressView()
            })
            Text(element.title ?? "")
                .font(.system(size: 26))
                .bold()
                .padding()
            Text(element.subtitle ?? "")
            VStack {
                ForEach(element.buttons ?? [], id: \.self) {button in
                    LargeButton(title:  AnyView(Text(button.title ?? "")),
                        backgroundColor: Color(hex: widgetColor.buttonBackColor) ?? Color.black,
                        foregroundColor: Color(hex: widgetColor.buttonFontColor) ?? Color.white)  {
                                    print("Click")
                                }
                }
            }
        }
        .padding()
    }
}
