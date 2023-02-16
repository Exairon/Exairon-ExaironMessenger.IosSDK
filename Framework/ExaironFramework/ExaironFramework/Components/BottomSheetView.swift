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
    var element: MenuElement
    var icon: String
    let chatViewModel: ChatViewModel

    //Image
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    //Gallery
    //@State private var selectedItem: PhotosPickerItem? = nil
    @State var galleryImage: UIImage? = nil
    @State var showGalleryPicker: Bool = false
    @State private var selectedImageData: Data? = nil
    //Document
    @State var showDocumentSheet = false
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
                            //imageDataProperties(data)
                            chatViewModel.sendFileMessage(filename: "\(UUID().uuidString).jpeg", mimeType: "image/jpeg", fileData: data)
                        }
                    }
                   
                }) {
                    PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
                }
            case .gallery:
                /*Button {
                    self.showDocumentSheet.toggle()
                } label: {
                    IconButtonView(text: "gallery", icon: icon)
                }*/
                Button {
                    self.showGalleryPicker.toggle()
                } label: {
                    IconButtonView(text: "gallery", icon: icon)
                }
                .sheet(isPresented: $showGalleryPicker) {
                    ImagePickerViewController(image: $galleryImage)
                }
                /*PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        IconButtonView(text: "gallery", icon: icon)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }*/
            case .file:
                Button {
                    self.showDocumentSheet.toggle()
                } label: {
                    IconButtonView(text: "file", icon: icon)
                }
                .sheet(isPresented: $showDocumentSheet) {
                    DocumentPicker()
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
                                        LargeButton(title: AnyView(Text(Localization.init().locale(key: "cancel"))),
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
                                    print(mapViewModel.region)
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill").font(.system(size: 40))
                                }
                                    .font(.system(size: 26))
                                    .padding(.horizontal, 10)
                                .padding()
                                .background(.black.opacity(0.75))
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
