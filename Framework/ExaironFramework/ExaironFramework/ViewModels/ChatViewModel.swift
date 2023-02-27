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
    let socketService = SocketService()
    @Published var messageText = ""
    @Published var widgetSettings: WidgetSettings? = nil
    @Published var messageArray: [Message] = []
    @Published var avatarUrl: String? = nil
    @Published var message: WidgetMessage? = nil
    @Published var showInputArea: Bool = true
    @Published var showingCredits = false
    @Published var fullScreenImageUrl: String? = nil
    @Published var fullScreenImageName: String? = nil

    func socketConnection(completion: @escaping (_ success: Bool) -> Void) {
        socketService.connect() { result in
            if result {
                completion(true)
            }
        }
    }
    
    func sessionRequest(completion: @escaping (_ success: String) -> Void) {
        let conversationId = readStringStorage(key: "conversationId")
        let sessionRequestObj = SessionRequest(session_id: conversationId, channelId: Exairon.shared.channelId)
        socketService.socketEmit(eventName: "session_request", object: sessionRequestObj)
        let socket = socketService.getSocket()
        socket?.once("session_confirm") {data, ack in
            guard let socketResponse = data[0] as? String else {
                return
            }
            if socketResponse != conversationId {
                self.writeMessage(messages: [])
            }
            completion(socketResponse)
        }
    }
    
    func changePage(page: Page, viewRouter: ViewRouter) {
        viewRouter.currentPage = page
    }
    
    func readStringStorage(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func writeStringStorage(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func addMessageFromSocket(data: [Any]) {
        do {
            let dat = try JSONSerialization.data(withJSONObject:data)
            let res = try JSONDecoder().decode([Message].self,from:dat)
            var botMessage = res[0]
            botMessage.timeStamp = Int64(NSDate().timeIntervalSince1970 * 1000)
            botMessage.sender = "bot_uttered"
            withAnimation {
                self.messageArray.append(botMessage)
                self.writeMessage(messages: self.messageArray)
            }
          }
          catch {
                print(error)
          }
    }
    
    func listenNewMessages() {
        let socket = socketService.getSocket()
        socket?.off("bot_uttered")
        socket?.off("system_uttered")
        socket?.on("bot_uttered") {data, ack in
            self.addMessageFromSocket(data: data)
        }
        socket?.on("system_uttered") {data, ack in
            self.addMessageFromSocket(data: data)
        }
    }
    
    func finishSession() {
        let sessionFinishRequest = SessionRequest(session_id: self.readStringStorage(key: "conversationId"), channelId: Exairon.shared.channelId)
        socketService.socketEmit(eventName: "finish_session", object: sessionFinishRequest)
    }
    
    func listenFinishSession() {
        let socket = socketService.getSocket()
        socket?.off("session_finished")
        socket?.on("session_finished") {data, ack in
            if self.widgetSettings?.data.showSurvey == true {
                let time = Int64(NSDate().timeIntervalSince1970 * 1000)
                let surveyMessage = Message(sender: "bot_uttered", type: "survey", timeStamp: time)
                withAnimation {
                    self.messageArray.append(surveyMessage)
                    self.writeMessage(messages: self.messageArray)
                }
                self.showInputArea = false
            } else {
                self.writeMessage(messages: [])
                self.writeStringStorage(value: "", key: "conversationId")
                self.showInputArea = false
            }
        }
    }
    
    func sendSurvey(value: Int, comment: String) {
        let surveyResult = ["value": value,
                            "comment": comment] as [String : Any]
        let surveyRequest = SurveyRequest(channelId: Exairon.shared.channelId, session_id: self.readStringStorage(key: "conversationId") ?? "", surveyResult: surveyResult)
        socketService.socketEmit(eventName: "send_survey_result", object: surveyRequest)
        self.writeMessage(messages: [])
        self.messageArray = []
        self.writeStringStorage(value: "", key: "conversationId")
        
    }

    func getWidgetSettings(viewRouter: ViewRouter, completion: @escaping(_ widgetSettings: WidgetSettings) -> Void) {
        apiService.getWidgetSettingsApiCall() { result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                self.sessionRequest() { socketResponse in
                    DispatchQueue.main.async {
                        self.widgetSettings = data
                        self.avatarUrl = Exairon.shared.src + "/uploads/channels/" + data.data.avatar
                        for _message in data.data.messages {
                            if(_message.lang == Exairon.shared.language) {
                                self.message = _message
                            }
                        }
                        if (self.message == nil) {
                            self.message = data.data.messages[0]
                        }
                        let oldConversationId = self.readStringStorage(key: "conversationId")
                        self.writeStringStorage(value: socketResponse, key: "conversationId")
                        if (oldConversationId == socketResponse) {
                            User.shared.name = Exairon.shared.name
                            User.shared.surname = Exairon.shared.surname
                            User.shared.email = Exairon.shared.email
                            User.shared.phone = Exairon.shared.phone
                            User.shared.user_unique_id = Exairon.shared.user_unique_id
                            self.changePage(page: .chatView, viewRouter: viewRouter)
                        } else {
                            if (!data.data.showUserForm || self.checkCustomerValues(formFields: data.data.formFields)) {
                                let userToken: String = self.readStringStorage(key: "userToken") ?? UUID().uuidString
                                self.writeStringStorage(value: userToken, key: "userToken")
                                User.shared.name = Exairon.shared.name
                                User.shared.surname = Exairon.shared.surname
                                User.shared.email = Exairon.shared.email
                                User.shared.phone = Exairon.shared.phone
                                User.shared.user_unique_id = Exairon.shared.user_unique_id
                                self.writeMessage(messages: [])
                                self.changePage(page: .chatView, viewRouter: viewRouter)
                            } else {
                                self.changePage(page: .formView, viewRouter: viewRouter)
                            }
                        }
                    }
                    completion(data)
                }
            }
        }
    }
    
    func getNewMessages(timestamp: String, conversationId: String, completion: @escaping(_ messages: MissingMessageResponse) -> Void) {
        apiService.getNewMessagesApiCall(timestamp: timestamp, conversationId: conversationId) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(data)
            }
        }
    }
    
    func checkCustomerValues(formFields: FormFields) -> Bool {
        let checkName = !formFields.showNameField || !(Exairon.shared.name == nil || Exairon.shared.name == "")
        let checkSurname = !formFields.showSurnameField || !(Exairon.shared.surname == nil || Exairon.shared.surname == "")
        let checkEmail = !formFields.showEmailField || !(Exairon.shared.email == nil || Exairon.shared.email == "")
        let checkPhone = !formFields.showPhoneField || !(Exairon.shared.phone == nil || Exairon.shared.phone == "")
        return checkName && checkSurname && checkEmail && checkPhone
    }

    func getBotResponse(type: String) -> Message {
        let time = Int64(NSDate().timeIntervalSince1970 * 1000)

        switch type {
        case "text":
            return Message(sender: "bot_uttered", type: "text", timeStamp: time, text: "text cevap")
        case "image":
            let payload = Payload(src: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png")
            let attachment = Attachment(payload: payload)
            return Message(sender: "bot_uttered", type: "image", timeStamp: time, attachment: attachment)
        case "button":
            let quickReply = QuickReply(title: "Button1", type: "postback")
            let quickReply2 = QuickReply(title: "Button2Button2Button2", type: "postback")
            let quickReply3 = QuickReply(title: "Button3", type: "postback")
            let quickReply4 = QuickReply(title: "Button4Button4", type: "postback")
            let quickReply5 = QuickReply(title: "Button5", type: "postback")
            return Message(sender: "bot_uttered", type: "button", timeStamp: time, text: "Button Message", quick_replies: [quickReply, quickReply2, quickReply3, quickReply4,quickReply5])
        case "local":
            let payload = Payload(src: "https://test.services.exairon.com/uploads/actions/action-1669969050848-whatsapp_video_2022-12-02_at_11.16.30.mp4", videoType: "local")
            let attachment = Attachment(payload: payload)
            return Message(sender: "bot_uttered", type: "video", timeStamp: time, attachment: attachment)
        case "youtube":
            let payload = Payload(src: "https://youtu.be/F4neLJQC1_E", videoType: "youtube")
            let attachment = Attachment(payload: payload)
            return Message(sender: "bot_uttered", type: "video", timeStamp: time, attachment: attachment)
        case "vimeo":
            let payload = Payload(src: "https://vimeo.com/718558198", videoType: "vimeo")
            let attachment = Attachment(payload: payload)
            return Message(sender: "bot_uttered", type: "video", timeStamp: time, attachment: attachment)
        case "audio":
            let payload = Payload(src: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
            let attachment = Attachment(payload: payload)
            let customData = CustomData(attachment: attachment)
            let custom = Custom(data: customData)
            return Message(sender: "bot_uttered", type: "audio", timeStamp: time, custom: custom)
        case "document":
            let payload = Payload(src: "https://test.services.exairon.com/uploads/chat/chat-1675281774491-ddd.pdf", originalname: "test.pdf")
            let attachment = Attachment(payload: payload)
            let customData = CustomData(attachment: attachment)
            let custom = Custom(data: customData)
            return Message(sender: "bot_uttered", type: "document", timeStamp: time, custom: custom)
        case "carousel":
            let quickReply = QuickReply(title: "Button1", type: "postback")
            let quickReply2 = QuickReply(title: "Button2Button2Button2", type: "postback")
            let quickReply3 = QuickReply(title: "Button3", type: "postback")
            let quickReply4 = QuickReply(title: "Button4Button4", type: "postback")
            let quickReply5 = QuickReply(title: "Button5", type: "postback")
            let element = Element(image_url: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png", subtitle: "subTitle1", title: "Title1", buttons: [quickReply, quickReply2])
            let element1 = Element(image_url: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png", subtitle: "subTitle2", title: "Title2", buttons: [quickReply3, quickReply4])
            let element2 = Element(image_url: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png", subtitle: "subTitle3", title: "Title3", buttons: [quickReply5])
            let element3 = Element(image_url: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png", subtitle: "subTitle4", title: "Title4", buttons: [quickReply5])
            let element4 = Element(image_url: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png", subtitle: "subTitle5", title: "Title5", buttons: [quickReply5])
            let element5 = Element(image_url: "https://test.services.exairon.com/uploads/actions/action-1672863218209-sdk3.png", subtitle: "subTitle6", title: "Title6", buttons: [quickReply5])
            let payload = Payload(elements: [element, element1, element2, element3, element4, element5])
            let attachment = Attachment(payload: payload)
            return Message(sender: "bot_uttered", type: "carousel", timeStamp: time, attachment: attachment)
        case "survey":
            return Message(sender: "bot_uttered", type: "survey", timeStamp: time)
        default:
            return Message(sender: "bot_uttered", type: "text", timeStamp: time, text: "Unsupported")
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
                // Decode data
                let data = try decoder.decode(Messages.self, from: data)
                self.messageArray = data.messages

                if (data.messages.count > 0) {
                    getNewMessages(timestamp: String(data.messages[data.messages.count-1].timeStamp ?? Int64(NSDate().timeIntervalSince1970 * 1000)), conversationId: self.readStringStorage(key: "conversationId") ?? "") { newMessages in
                        DispatchQueue.main.async {
                            withAnimation {
                                self.messageArray += newMessages.data
                            }
                        }
                        self.writeMessage(messages: data.messages + newMessages.data)
                    }
                } else {
                }
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    func initializeChatView() {
        self.showInputArea = true
        self.readMessage()
        self.listenNewMessages()
        self.listenFinishSession()
        let c_id = self.readStringStorage(key: "conversationId")
        let messageCount = self.messageArray.count
        var lastMessage: Message?
        if messageCount > 0 {
            lastMessage = self.messageArray[messageCount-1]
        } else {
            lastMessage = nil
        }
        if c_id == nil || c_id == "" || lastMessage?.type == "survey" {
            writeMessage(messages: [])
            self.messageArray = []
            self.sessionRequest() { socketResponse in
                DispatchQueue.main.async {
                    self.writeStringStorage(value: socketResponse, key: "conversationId")
                }
            }
        }
        if widgetSettings?.triggerRules.count ?? 0 > 0 {
            if messageArray.count == 0 && widgetSettings?.triggerRules[0].enabled == true {
                sendMessage(message: widgetSettings?.triggerRules[0].text ?? "", ruleMessage: true)
            }
        }
    }
    
    func getUserMap() -> Dictionary<String, String> {
        return ["name": User.shared.name ?? "",
                "surname": User.shared.surname ?? "",
                "email": User.shared.email ?? "",
                "phone": User.shared.phone ?? "",
                "user_unique_id": User.shared.user_unique_id ?? ""]
    }
    
    
    func sendMessage(message: String, payload: String? = nil, ruleMessage: Bool? = false) {
        withAnimation {
            self.messageText = ""
            let newMessage = Message(sender: "user_uttered", type: "text", timeStamp: Int64(NSDate().timeIntervalSince1970 * 1000), text: message, ruleMessage: ruleMessage)
            self.messageArray.append(newMessage)
        }
        let user = getUserMap()
        let messageString: String = payload ?? message
        let sendMessageModel = SocketMessage(channel_id: Exairon.shared.channelId, message: messageString, session_id: self.readStringStorage(key: "conversationId") ?? "", userToken: self.readStringStorage(key: "userToken") ?? "", user: user)
        socketService.socketEmit(eventName: "user_uttered", object: sendMessageModel)
        self.writeMessage(messages: self.messageArray)
    }
    
    func sendFileMessage(filename: String, mimeType: String, fileData: Data) {
        showingCredits.toggle()
        let conversationId: String = self.readStringStorage(key: "conversationId") ?? ""
        apiService.uploadFileApiCall(conversationId: conversationId, filename: filename, mimeType: mimeType, fileData: fileData) {result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                let file = ["document": data.data.url,
                            "mimeType": data.data.mimeType,
                            "originalname": data.data.originalname]
                let user = self.getUserMap()
                let sendMessageModel = SocketFileMessage(channel_id: Exairon.shared.channelId, message: file, session_id: self.readStringStorage(key: "conversationId") ?? "", userToken: self.readStringStorage(key: "userToken") ?? "", user: user)
                var attachment: Attachment?
                var custom: Custom?
                var messageType = "image"
                let timeStamp = Int64(NSDate().timeIntervalSince1970 * 1000)
                
                if mimeType.contains("image") {
                    let payload = Payload(src: data.data.url, originalname: data.data.originalname)
                    attachment = Attachment(payload: payload)
                } else {
                    let payload = Payload(src: data.data.url, originalname: data.data.originalname)
                    let documentAttachment = Attachment(payload: payload)
                    let customData = CustomData(attachment: documentAttachment)
                    custom = Custom(data: customData)
                    messageType = "document"
                }
                
                let newMessage = Message(sender: "user_uttered", type: messageType, timeStamp: timeStamp, attachment: attachment, custom: custom)
                
                self.socketService.socketEmit(eventName: "user_uttered", object: sendMessageModel)

                withAnimation {
                    self.messageArray.append(newMessage)
                }
                self.writeMessage(messages: self.messageArray)
            }
        }
    }
    
    func sendLocationMessage(latitude: Double, longitude: Double) {
        showingCredits.toggle()
        withAnimation {
            let location = Location(latitude: latitude, longitude: longitude)
            let newMessage = Message(sender: "user_uttered", type: "location", timeStamp: Int64(NSDate().timeIntervalSince1970 * 1000), location: location)
            self.messageArray.append(newMessage)
        }
        let user = getUserMap()
        let userToken = self.readStringStorage(key: "userToken") ?? ""
        let conversationId = self.readStringStorage(key: "conversationId") ?? ""
        let longLat = ["latitude": latitude, "longitude": longitude]
        let locationMessage = ["location": longLat]
        let sendMessageModel = SocketLocationMessage(channel_id: Exairon.shared.channelId, message: locationMessage, session_id: conversationId, userToken: userToken, user: user)
        socketService.socketEmit(eventName: "user_uttered", object: sendMessageModel)
        self.writeMessage(messages: self.messageArray)
    }
}
