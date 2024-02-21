//
//  RecentMessage.swift
//  ChatApp
//
//  Created by Hamada Salhab on 13.02.2024.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable {
    let documentID, fromID, toID, text: String
    let timestamp: Date
    var profilePicURL, fullName: String
    var id: String {documentID}
    
    var sent: Bool {
        FirebaseManager.shared.auth.currentUser?.uid == fromID
    }
    
    var received: Bool {
        FirebaseManager.shared.auth.currentUser?.uid == toID
    }
    
    init(documentID: String, data: [String:Any]) {
        self.documentID = documentID
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.profilePicURL = data["profilePicURL"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp ?? Timestamp()).dateValue()
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self.timestamp, relativeTo: Date())
    }
}
