//
//  MissingMessageModel.swift
//  ExaironFramework
//
//  Created by Exairon on 13.02.2023.
//

import Foundation

// MARK: - MissingMessage
struct MissingMessageResponse: Codable {
    let status: String
    let results: Int
    let data: [Message]
}
