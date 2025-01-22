//
//  ChatAppUser.swift
//  Messenger
//
//  Created by Alibek Baisholanov on 22.01.2025.
//

import Foundation

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
//    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
