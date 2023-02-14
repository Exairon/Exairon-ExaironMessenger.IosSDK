//
//  BottomSheetView.swift
//  ExaironFramework
//
//  Created by Exairon on 14.02.2023.
//

import SwiftUI

struct BottomSheetView: View {
    //@State var showingCredits: Bool

    var body: some View {
        HStack {
            VStack {
                BottomSheetElementView(text: "camera", icon: "camera")
                Divider()
                BottomSheetElementView(text: "gallery", icon: "photo")
                Divider()
                BottomSheetElementView(text: "file", icon: "doc")
                Divider()
                BottomSheetElementView(text: "location", icon: "location")
            }
            /*VStack(alignment:.trailing) {
                HStack {
                    Spacer()
                    Button {
                        self.showingCredits.toggle()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }*/
        }
        .padding()
    }
}

struct BottomSheetElementView: View {
    var text: String
    var icon: String
    var body: some View {
        VStack {
            Button {
                print(text)
            } label: {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundColor(Color(hex: "#2A516F"))
                    Text(Localization.init().locale(key: text))
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "#2A516F"))
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
        }
        .padding(.vertical, 10)
    }
}
