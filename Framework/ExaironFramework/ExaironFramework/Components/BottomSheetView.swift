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
                Divider()
                BottomSheetElementView(element: .location, icon: "location", chatViewModel: chatViewModel)
            }
        }
        .padding()
    }
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
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        VStack {
            switch(element) {
            case .camera:
                Button {
                    self.showImagePicker.toggle()
                } label: {
                    IconButtonView(text: "camera", icon: icon)
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
                    IconButtonView(text: "gallery", icon: icon)
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
                    IconButtonView(text: "file", icon: icon)
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
                    IconButtonView(text: "location", icon: icon)
                }
                .sheet(isPresented: $showMapSheet) {
                    ZStack {
                        if #available(iOS 16.0, *) {
                            Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true)
                                .ignoresSafeArea()
                                .presentationDetents([.height(UIScreen.main.bounds.height * 0.7)])
                                .onAppear {
                                    mapViewModel.checkIfLocationServicesIsEnabled()
                                }
                        } else {
                            VStack {
                                HStack {
                                    Button {
                                        self.showMapSheet.toggle()
                                    } label: {
                                        LargeButton(title: AnyView(Text(Localization.init().locale(key: "cancel")).font(.custom("OpenSans", size: 18))),
                                            backgroundColor: Color.white,
                                            foregroundColor: Color.blue) {
                                                self.showMapSheet.toggle()
                                            }
                                    }
                                    Spacer()
                                }.padding()
                                Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true)
                                    .onAppear {
                                        mapViewModel.checkIfLocationServicesIsEnabled()
                                    }
                            }
                        }
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    showMapSheet.toggle()
                                    let latitude = Double(mapViewModel.region.center.latitude)
                                    let longitude = Double(mapViewModel.region.center.longitude)
                                    chatViewModel.sendLocationMessage(latitude: latitude, longitude: longitude)
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill").font(.system(size: 40))
                                }
                                    .font(.system(size: 26))
                                    .padding(.horizontal, 10)
                                .padding()
                                .background(Color(hex: "#1E1E1E40"))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                            }
                        }
                    }
                    
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
                .font(.custom("OpenSans", size: 24))
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
