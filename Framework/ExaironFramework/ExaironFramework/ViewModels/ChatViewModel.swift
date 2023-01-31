//
//  ChatViewModel.swift
//  ExaironFramework
//
//  Created by Exairon on 27.01.2023.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    let apiService = ApiService()
    @Published var messageText = ""
    @Published var widgetSettings: WidgetSettings? = nil
    @Published var messageArray: [Message] = []
    
    func getWidgetSettings(completion: @escaping(_ widgetSettings: WidgetSettings) -> Void) {
        apiService.getWidgetSettingsApiCall() { result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    DispatchQueue.main.async {
                        self.widgetSettings = data
                    }
                    completion(data)
            }
        }
    }
    
    func getBotResponse(message: String) -> String {
        let tempMessage = message.lowercased()
        
        if tempMessage.contains("hello") {
            return "Hey there!"
        } else if tempMessage.contains("goodbye"){
            return "Bye"
        } else {
            return "I don't understand bro"
        }
    }
    
    func writeMessage(messages: [Message]){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            print(messages.count)
            let messagesss = Messages(messages: messages)
            let data = try encoder.encode(messagesss)
            UserDefaults.standard.set(data, forKey: "messages")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func readMessage() {
        if let data = UserDefaults.standard.data(forKey: "messages") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let note = try decoder.decode(Messages.self, from: data)
                self.messageArray = note.messages
                for __message in note.messages {
                    print(__message.text ?? "")
                }
            

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    func sendMessage(message: String) {
        withAnimation {
            self.messageText = ""
            let newMessage = Message(text: message, type: "user_uttered", messageType: "text", time: Int64(NSDate().timeIntervalSince1970 * 1000))
            self.messageArray.append(newMessage)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                let newMessage = Message(text: self.getBotResponse(message: message), type: "bot_uttered", messageType: "text", time: Int64(NSDate().timeIntervalSince1970 * 1000))
                self.messageArray.append(newMessage)
                self.writeMessage(messages: self.messageArray)
            }
        }
    }
}
