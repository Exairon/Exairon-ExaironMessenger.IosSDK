//
//  BottomSheetView.swift
//  ExaironFramework
//
//  Created by Exairon on 14.02.2023.
//

import SwiftUI
import PhotosUI

struct BottomSheetView: View {
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
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var text: String
    var icon: String
    var body: some View {
        VStack {
            switch(text) {
            case "gallery":
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        IconButtonView(text: text, icon: icon)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
            default:
                Button {
                    print(text)
                } label: {
                    IconButtonView(text: text, icon: icon)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

struct IconButtonView: View {
    var text: String
    var icon: String
    var body: some View {
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
