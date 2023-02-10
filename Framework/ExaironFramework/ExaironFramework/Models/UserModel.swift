//
//  UserModel.swift
//  ExaironFramework
//
//  Created by Exairon on 10.02.2023.
//

import Foundation

class User {
    public static let shared = User()
    var name: String? = nil
    var surname: String? = nil
    var email: String? = nil
    var phone: String? = nil
}
