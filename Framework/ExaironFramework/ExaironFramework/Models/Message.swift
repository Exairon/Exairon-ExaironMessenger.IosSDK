//
//  Message.swift
//  ExaironFramework
//
//  Created by Exairon on 31.01.2023.
//

import Foundation

// MARK: - Messages
struct Messages: Codable {
    let messages: [Message]
}

// MARK: - Message
struct Message: Codable, Hashable {
    let type: String
    let messageType: String
    let time: Int64
    var text: String? = nil
    var attachment: Attachment? = nil
    var quick_replies: [QuickReply]? = nil
}

// MARK: - Attachment
struct Attachment: Codable, Hashable {
    var type: String? = nil
    var payload: Payload? = nil
}

// MARK: - Payload
struct Payload: Codable, Hashable {
    var src: String? = nil
    var videoType: String? = nil
    var mimeType: String? = nil
    var originalname: String? = nil
    var elements: [Elemenet]? = nil
}

// MARK: - Elemenet
struct Elemenet: Codable, Hashable {
    var image_url: String? = nil
}

// MARK: - QuickReply
struct QuickReply: Codable, Hashable {
    var content_type: String? = nil
    var payload: String? = nil
    var title: String? = nil
    var type: String? = nil
    var url: String? = nil
}




