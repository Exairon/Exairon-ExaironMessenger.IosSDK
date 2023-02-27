//
//  MapView.swift
//  ExaironFramework
//
//  Created by Exairon on 27.02.2023.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @State var showMapSheet: Bool
    
    var body: some View {
        ZStack {
            CustomMapView(chatViewModel: chatViewModel)
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if chatViewModel.selectedLocationLatitude != nil {
                            chatViewModel.sendLocationMessage(latitude: chatViewModel.selectedLocationLatitude ?? 0, longitude: chatViewModel.selectedLocationLongitude ?? 0)
                            self.showMapSheet.toggle()
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill").font(.system(size: 40))
                    }
                }
                .padding()
            }
        }
    }
}
