//
//  DocumentViewController.swift
//  ExaironFramework
//
//  Created by Exairon on 14.02.2023.
//

import Foundation
import UIKit
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileUrl: URL?
    
    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", "com.adobe.pdf", "com.microsoft.excel.xls", "org.openxmlformats.spreadsheetml.sheet"], in: .import)
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
            parent.fileUrl = urls.first
        }
    }
}
