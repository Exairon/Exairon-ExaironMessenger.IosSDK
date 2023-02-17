//
//  LocationMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 16.02.2023.
//

import SwiftUI
import MapKit

struct LocationMessageView: View {
    @State var message: Message
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                let coordinate = CLLocationCoordinate2DMake(message.location?.latitude ?? 0 ,message.location?.longitude ?? 0)
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
                mapItem.name = "Target location"
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            } label: {
                Image(systemName: "location.north.circle")
                    .padding()
                    .font(.system(size: 48))
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }.padding(.horizontal)
    }
}
