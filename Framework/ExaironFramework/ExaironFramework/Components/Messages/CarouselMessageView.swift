//
//  CarouselMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 2.02.2023.
//

import SwiftUI

struct CarouselMessageView: View {
    
    @State var elements: [Element]
    @State var widgetSettings: WidgetSettings
    @State private var index = 0
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
        
    var body: some View {
            
            ZStack {
                ForEach(elements.indices, id: \.self) { i in
                    CarouselCardView(element: self.elements[i], widgetColor: widgetSettings.data.color)
                        .frame(width: 200)
                        .background(Color(hex: "E4E4E7"))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .scaleEffect(1.0 - abs(distance(i + 1)) * 0.2 )
                        .opacity(1.0 - abs(distance(i + 1)) * 0.3 )
                        .offset(x: myXOffset(i + 1), y: 0)
                        .zIndex(1.0 - abs(distance(i + 1)) * 0.1)
                    
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        draggingItem = snappedItem + value.translation.width / 100
                    }
                    .onEnded { value in
                        withAnimation {
                            print(snappedItem)
                            print(draggingItem)

                            draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                            draggingItem = round(draggingItem).remainder(dividingBy: Double(elements.count))
                            snappedItem = draggingItem
                        }
                    }
            )
        }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(elements.count))
    }
        
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(elements.count) * distance(item)
        return sin(angle) * 200
    }
    
    init(message: Message, widgetSettings: WidgetSettings) {
        self.elements = message.attachment?.payload?.elements ?? []
        self.widgetSettings = widgetSettings
    }
}
