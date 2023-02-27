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
    @State private var showingFileAlert = false
    //Location
    @State var showMapSheet = false

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
                                let resources = try fileUrl!.resourceValues(forKeys:[.fileSizeKey])
                                if resources.fileSize ?? 0 <= 1000000 {
                                    let fileData = try Data(contentsOf: fileUrl ?? URL(fileURLWithPath: ""))
                                    let mimeType = fileUrl?.relativeString.mimeType()
                                    chatViewModel.sendFileMessage(filename: fileUrl?.lastPathComponent ?? "", mimeType: mimeType ?? "", fileData: fileData)
                                } else {
                                    showingFileAlert.toggle()
                                }
                                
                            } catch {
                                print(error)
                            }
                        }
                    }
                }) {
                    DocumentPicker(fileUrl: $fileUrl)
                }
                .alert(isPresented: $showingFileAlert) {
                    Alert(title: Text("File Size Error"), message: Text("Max file size 1MB"), dismissButton: .cancel())
                }
            case .location:
                Button {
                    self.showMapSheet.toggle()
                } label: {
                    IconButtonView(chatViewModel: chatViewModel, text: "location", icon: icon)
                }
                .sheet(isPresented: $showMapSheet, onDismiss: {
                    Task {
                        chatViewModel.showingCredits.toggle()
                        chatViewModel.selectedLocationLatitude = nil
                        chatViewModel.selectedLocationLongitude = nil
                    }
                }) {
                    ZStack {
                        MapView(chatViewModel: chatViewModel)
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
        }
        .padding(.vertical, 10)
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
