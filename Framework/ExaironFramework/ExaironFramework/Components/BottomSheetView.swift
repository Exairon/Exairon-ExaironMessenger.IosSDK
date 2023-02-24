//
//  BottomSheetView.swift
//  ExaironFramework
//
//  Created by Exairon on 14.02.2023.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit
import MapKit

enum MenuElement {
    case camera
    case gallery
    case file
    case location
}

struct BottomSheetView: View {
    let chatViewModel: ChatViewModel
    
    var body: some View {
        HStack {
            VStack {
                BottomSheetElementView(element: .camera, icon: "camera", chatViewModel: chatViewModel)
                Divider()
                BottomSheetElementView(element: .gallery, icon: "photo", chatViewModel: chatViewModel)
                Divider()
                BottomSheetElementView(element: .file, icon: "doc", chatViewModel: chatViewModel)
                //Divider()
                //BottomSheetElementView(element: .location, icon: "location", chatViewModel: chatViewModel)
            }
        }
        .padding()
    }
}

struct Landmark: Equatable {
    static func ==(lhs: Landmark, rhs: Landmark) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID().uuidString
    let name: String
    let location: CLLocationCoordinate2D
}

struct BottomSheetElementView: View {
    var element: MenuElement
    var icon: String
    let chatViewModel: ChatViewModel

    //Image
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    //Gallery
    @State var galleryImage: UIImage? = nil
    @State var showGalleryPicker: Bool = false
    @State private var selectedImageData: Data? = nil
    //Document
    @State var showDocumentSheet = false
    @State var fileUrl: URL? = nil
    //Location
    @State var showMapSheet = false
    //@StateObject private var mapViewModel = MapViewModel()
    @State var selectedLandmark: Landmark? = nil
    @State var landmarks: [Landmark] = [
            Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
            Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
            Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
        ]
    var body: some View {
        VStack {
            switch(element) {
            case .camera:
                Button {
                    self.showImagePicker.toggle()
                } label: {
                    IconButtonView(chatViewModel: chatViewModel, text: "camera", icon: icon)
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    Task {
                        if let data = image?.jpegData(compressionQuality: 0.1) {
                            chatViewModel.sendFileMessage(filename: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg", fileData: data)
                        }
                    }
                }) {
                    PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
                }
            case .gallery:
                Button {
                    self.showGalleryPicker.toggle()
                } label: {
                    IconButtonView(chatViewModel: chatViewModel, text: "gallery", icon: icon)
                }
                .sheet(isPresented: $showGalleryPicker, onDismiss: {
                    Task {
                        if let data = galleryImage?.jpegData(compressionQuality: 0.1) {
                            chatViewModel.sendFileMessage(filename: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg", fileData: data)
                        }
                    }
                }) {
                    ImagePickerViewController(image: $galleryImage)
                }
            case .file:
                Button {
                    self.showDocumentSheet.toggle()
                } label: {
                    IconButtonView(chatViewModel: chatViewModel, text: "file", icon: icon)
                }
                .sheet(isPresented: $showDocumentSheet, onDismiss: {
                    Task {
                        if fileUrl != nil {
                            do {
                                let fileData = try Data(contentsOf: fileUrl ?? URL(fileURLWithPath: ""))
                                let mimeType = fileUrl?.relativeString.mimeType()
                                chatViewModel.sendFileMessage(filename: fileUrl?.lastPathComponent ?? "", mimeType: mimeType ?? "", fileData: fileData)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }) {
                    DocumentPicker(fileUrl: $fileUrl)
                }
            case .location:
                Button {
                    self.showMapSheet.toggle()
                } label: {
                    IconButtonView(chatViewModel: chatViewModel, text: "location", icon: icon)
                }
                .sheet(isPresented: $showMapSheet) {
                    ZStack {
                        MapView(landmarks: $landmarks,
                                selectedLandmark: $selectedLandmark)
                        .onTapGesture{
                            print("enes")
                        }
                            .edgesIgnoringSafeArea(.vertical)
                        VStack {
                            Spacer()
                            Button(action: {
                                self.selectNextLandmark()
                            }) {
                                Text("Next")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                                    .padding(.bottom)
                            }
                        }
                    }
                    
                }
            }
        }
        .padding(.vertical, 10)
    }

    private func selectNextLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex + 1 < landmarks.endIndex {
            self.selectedLandmark = landmarks[currentIndex + 1]
        } else {
            selectedLandmark = landmarks.first
        }
    }
}

struct IconButtonView: View {
    @State var chatViewModel: ChatViewModel
    var text: String
    var icon: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(Color(hex: "#2A516F"))
            Text(Localization.init().locale(key: text))
                .font(.custom(chatViewModel.widgetSettings?.data.font ?? "OpenSans", size: 24))
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
