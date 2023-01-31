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
    var text: String? = nil
    let type: String
    let time: Int64
}
