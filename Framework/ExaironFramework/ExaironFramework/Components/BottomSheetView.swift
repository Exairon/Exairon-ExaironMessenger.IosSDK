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
    var body: some View {
        HStack {
            VStack {
                BottomSheetElementView(element: .camera, icon: "camera")
                Divider()
                BottomSheetElementView(element: .gallery, icon: "photo")
                Divider()
                BottomSheetElementView(element: .file, icon: "doc")
                Divider()
                BottomSheetElementView(element: .location, icon: "location")
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
    //Gallery
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    //Document
    @State var showDocumentSheet = false
    //Location
    @State var showMapSheet = false
    @StateObject private var mapViewModel = MapViewModel()
    
    var element: MenuElement
    var icon: String
    
    var body: some View {
        VStack {
            switch(element) {
            case .camera:
                Button {
                    print("click")
                } label: {
                    IconButtonView(text: "camera", icon: icon)
                }
            case .gallery:
                PhotosPicker(
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
                    }
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
                        Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true)
                            .ignoresSafeArea()
                            .presentationDetents([.height(UIScreen.main.bounds.height * 0.7)])
                            .onAppear {
                                mapViewModel.checkIfLocationServicesIsEnabled()
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

struct DocumentPicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker) {
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print(urls.first?.deletingPathExtension().lastPathComponent ?? "")
        }
    }
}
