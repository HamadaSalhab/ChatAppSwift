//
//  ConversationViewViewModel.swift
//  ChatApp
//
//  Created by Hamada Salhab on 08.02.2024.
//

import Foundation
import Firebase
import FirebaseFirestore


class ConversationViewViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var otherUser: User?
    @Published var otherUserID = ""
    @Published var messageText = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    @Published var messageData = [String:Any]()
    
    private var currentUserID: String {
        currentUser?.id ?? ""
    }
    
    init() { }
    
    @MainActor
    func asyncSetup(otherUserID: String) async {
        self.otherUserID = otherUserID
        do {
            self.currentUser = try await fetchCurrentUser()
            self.otherUser = try await fetchOtherUser()
        } catch {
            print(error)
        }
        self.messageData["fromID"] = self.currentUser?.id
        self.messageData["toID"] = otherUserID
        self.fetchMessages()
    }
    
    private func fetchCurrentUser() async throws -> User {
        guard let userID = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Couldn't get the current user id")
            throw "Couldn't get the current user id"
        }
        let userDocument = FirebaseManager.shared.firestore.collection("users")
            .document(userID)
        
        do {
            let user = try await userDocument.getDocument(as: User.self)
            return user
        } catch {
            throw error
        }
    }
    
    private func fetchOtherUser() async throws -> User {
        let userDocument = FirebaseManager.shared.firestore.collection("users")
            .document(self.otherUserID)
        do {
            let user = try await userDocument.getDocument(as: User.self)
            return user
        } catch {
            throw error
        }
    }
    
//    func sendMessage() {
//        self.messageData["text"] = messageText
//        self.messageData["timestamp"] = Timestamp()
//        
//        let senderDocument = FirebaseManager.shared.firestore.collection("messages")
//            .document(currentUserID)
//            .collection(otherUserID)
//            .document()
//        
//        senderDocument.setData(messageData) { error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//        }
//        
//        let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
//            .document(otherUserID)
//            .collection(currentUserID)
//            .document()
//        
//        recipientDocument.setData(messageData) { error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//        }
//        
//        persistRecentMessage(recentMessageData: messageData)
//        
//        self.messageText = ""
//        self.count += 1
//    }
//    
//    private func persistRecentMessage(recentMessageData: [String:Any]) {
//        messageData["profilePicURL"] = self.otherUser!.profilePicURL
//        messageData["fullName"] = self.otherUser!.fullName
//        
//        let senderDocument = FirebaseManager.shared.firestore.collection("recent_messages")
//            .document(currentUserID)
//            .collection("messages")
//            .document(otherUserID)
//        
//        senderDocument.delete()
//        
//        senderDocument.setData(messageData) { error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//        }
//        
//        messageData["profilePicURL"] = self.currentUser!.profilePicURL
//        messageData["fullName"] = self.currentUser!.fullName
//        
//        let recipientDocument = FirebaseManager.shared.firestore.collection("recent_messages")
//            .document(otherUserID)
//            .collection("messages")
//            .document(currentUserID)
//        
//        recipientDocument.delete()
//        
//        recipientDocument.setData(messageData) { error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//        }
//    }
//    
    
    @MainActor
    func sendMessage() async {
        self.messageData["text"] = messageText
        self.messageData["timestamp"] = Timestamp()
        
        let senderDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(currentUserID)
            .collection(otherUserID)
            .document()
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(otherUserID)
            .collection(currentUserID)
            .document()
        
        do {
            try await senderDocument.setData(messageData)
            try await recipientDocument.setData(messageData)
            try await persistRecentMessage(recentMessageData: messageData)
        } catch {
            print("Error: \(error)")
        }
        
        self.messageText = ""
        self.count += 1
    }
    
    private func persistRecentMessage(recentMessageData: [String:Any]) async throws {
        let senderDocument = FirebaseManager.shared.firestore.collection("recent_messages")
            .document(currentUserID)
            .collection("messages")
            .document(otherUserID)
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("recent_messages")
            .document(otherUserID)
            .collection("messages")
            .document(currentUserID)
        
        do {
            try await senderDocument.delete()
            try await recipientDocument.delete()
            
            messageData["profilePicURL"] = self.otherUser!.profilePicURL
            messageData["fullName"] = self.otherUser!.fullName
            try await senderDocument.setData(messageData)

            messageData["profilePicURL"] = self.currentUser!.profilePicURL
            messageData["fullName"] = self.currentUser!.fullName
            try await recipientDocument.setData(messageData)
        } catch {
            print("Error while deleting recent message documents. Detailed error: \(error)")
        }
    }
    
    @MainActor
    func fetchMessages() {
        FirebaseManager.shared.firestore.collection("messages")
            .document(currentUserID)
            .collection(otherUserID)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach { change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentID: change.document.documentID, data: data))
                    }
                }
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
}
