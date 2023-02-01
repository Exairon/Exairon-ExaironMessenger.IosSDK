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
    
    func getBotResponse(type: String) -> Message {
        let time = Int64(NSDate().timeIntervalSince1970 * 1000)

        switch type {
        case "text":
            return Message(type: "bot_uttered", messageType: "text", time: time, text: "text cevap")
        case "image":
            let payload = Payload(src: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png")
            let attachment = Attachment(payload: payload)
            return Message(type: "bot_uttered", messageType: "image", time: time, attachment: attachment)
        case "button":
            let quickReply = QuickReply(title: "Button1", type: "postback")
            let quickReply2 = QuickReply(title: "Button2Button2Button2", type: "postback")
            let quickReply3 = QuickReply(title: "Button3", type: "postback")
            let quickReply4 = QuickReply(title: "Button4Button4", type: "postback")
            let quickReply5 = QuickReply(title: "Button5", type: "postback")
            return Message(type: "bot_uttered", messageType: "button", time: time, text: "Button Message", quick_replies: [quickReply, quickReply2, quickReply3, quickReply4,quickReply5])
        case "video":
            let payload = Payload(src: "https://test.services.exairon.com/uploads/actions/action-1669969050848-whatsapp_video_2022-12-02_at_11.16.30.mp4", videoType: "local")
            let attachment = Attachment(payload: payload)
            return Message(type: "bot_uttered", messageType: "video", time: time, attachment: attachment)
        default:
            return Message(type: "bot_uttered", messageType: "text", time: time, text: "Unsupported")
        }
    }
    
    func writeMessage(messages: [Message]){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
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
            let newMessage = Message(type: "user_uttered", messageType: "text", time: Int64(NSDate().timeIntervalSince1970 * 1000), text: message)
            self.messageArray.append(newMessage)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                let messageType = message.lowercased()
                let botMessage = self.getBotResponse(type: messageType)
                
                self.messageArray.append(botMessage)
                self.writeMessage(messages: self.messageArray)
            }
        }
    }
}
