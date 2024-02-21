//
//  User.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let fullName: String
    let email: String?
    let profilePicURL: String
//    let joined: TimeInterval
    
    init (id: String, fullName: String, email: String, profilePicURL: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.profilePicURL = profilePicURL
    }
    
    init () {
        self.id = ""
        self.fullName = ""
        self.email = ""
        self.profilePicURL = ""
    }
    
    init (id: String, fullName: String, profilePicURL: String) {
        self.id = id
        self.fullName = fullName
        self.email = nil
//        self.email = email
        self.profilePicURL = profilePicURL
    }
    
    init (fromDictionary data: [String:Any]) {
        self.id = data["id"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profilePicURL = data["profilePicURL"] as? String ?? ""
    }
}
