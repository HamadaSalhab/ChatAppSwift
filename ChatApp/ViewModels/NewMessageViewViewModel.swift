//
//  NewMessageViewViewModel.swift
//  ChatApp
//
//  Created by Hamada Salhab on 07.02.2024.
//


import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewMessageViewViewModel: ObservableObject {
    @Published var users: [User]
    
    init () {
        self.users = [User]()
        self.fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error happened: \(error.localizedDescription)")
            }
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach({ sn in
                let data = sn.data()
                if data["id"] as? String != FirebaseManager.shared.auth.currentUser?.uid {
                    self.users.append(User(fromDictionary: data))
                }
            }
            )
        }
    }
}
