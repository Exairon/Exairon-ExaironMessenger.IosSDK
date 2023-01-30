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
    @Published var messages: [String] = []
    @Published var messageText = ""
    @Published var widgetSettings: WidgetSettings? = nil
    
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
    
    func sendMessage(message: String) {
        withAnimation {
            self.messages.append("[USER]" + message)
            self.messageText = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.messages.append(self.getBotResponse(message: message))
            }
        }
    }
}
