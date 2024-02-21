//
//  RegisterViewViewModel.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class RegisterViewViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var profilePicture = UIImage()
    @Published var showImagePicker = false
    @Published var errorMessage = ""
    
    init() { }
    
    func register() {
        print("Attempting to register...")
        
        guard validate() else {
            print("Error while validating registration info.")
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userID = result?.user.uid else {
                return
            }
            
            self?.saveProfilePicToFirebaseStorage(userID: userID)
            
            print("Successfully registered")

        }
    }
    
    private func insertUserRecord(id: String, profilePicURL: String) {
        let newUser = User(
            id: id,
            fullName: fullName,
            email: email,
            profilePicURL: profilePicURL
        )
        
        
        FirebaseManager.shared.firestore.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
        
        print("Successfully wrote user data to database")
    }
    
    
    private func validate () -> Bool {
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "The password needs to be at least 6 characters long."
            return false
        }
        
        return true
    }
    
    private func saveProfilePicToFirebaseStorage (userID: String) {
        let imagePath = "profile-pictures/\(userID).jpeg"
        let ref = FirebaseManager.shared.storage.reference(withPath: imagePath)
        guard let imageData = profilePicture.jpegData(compressionQuality: 0.5) else {
            print("Error while getting png data from image")
            return
        }
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error while putting data in the reference. Error message: \(error)")
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print("Error while downloading image url. Error Message: \(error)")
                    return
                }
                let profilePicURL = url?.absoluteString ?? ""
                print("prfilePicUrl while saving: \(profilePicURL)")
                self.insertUserRecord(id: userID, profilePicURL: profilePicURL)
            }
        }
    }
}
