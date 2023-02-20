//
//  DocumentMessageView.swift
//  ExaironFramework
//
//  Created by Exairon on 1.02.2023.
//

import SwiftUI
import Foundation

struct DocumentMessageView: View {
    @State var message: Message
    
    var body: some View {
        HStack {
            if message.sender.contains("user_uttered") {
                Spacer()
            }
            Button(action: downloadFile) {
                HStack {
                    Image(systemName: "doc.fill")
                    Text(message.custom?.data?.attachment?.payload?.originalname ?? "empty")
                        .font(.custom("OpenSans", size: 18))
                }
                .padding()
                .foregroundColor(.white)
                .background(.gray)
                .cornerRadius(10)
            }
            if !message.sender.contains("user_uttered") {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
    
    func downloadFile() {
        let filename = message.custom?.data?.attachment?.payload?.originalname ?? ""
        let urlString = message.custom?.data?.attachment?.payload?.src ?? ""

        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(filename)
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
     
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "")
            }
        }
        task.resume()
    }
}
