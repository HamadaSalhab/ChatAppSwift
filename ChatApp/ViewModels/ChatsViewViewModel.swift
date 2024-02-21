//
//  ChatsViewViewModel.swift
//  ChatApp
//
//  Created by Hamada Salhab on 07.02.2024.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Foundation

struct DisplayableError: Error, LocalizedError {
    let errorDescription: String?
    init(_ description: String) {
        errorDescription = description
    }
}

class ChatsViewViewModel: ObservableObject {
    @Published var user: User?
    @Published var recentMessages = [RecentMessage]()
    
    init () {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        fetchUser(userID: userID)
        fetchRecentMessages(userID: userID)
    }
    
    init(withPreDefinedID userID: String) {
        fetchUser(userID: userID)
    }
    
    private func fetchUser (userID: String) {
        FirebaseManager.shared.firestore.collection("users")
            .document(userID).getDocument { snapshot, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = snapshot?.data() else {
                    print("Error: user fetching data snapshot is empty")
                    return
                }
                self.user = User(fromDictionary: data)
            }
    }
    
    private func fetchRecentMessages(userID: String) {
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(userID)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docID = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { recentMessage in
                        return recentMessage.documentID == docID
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    let recentMessage = RecentMessage(documentID: docID, data: change.document.data())
                    self.recentMessages.insert(recentMessage, at: 0)
                })
            }
    }
}
