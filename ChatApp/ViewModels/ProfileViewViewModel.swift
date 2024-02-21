//
//  ProfileViewViewModel.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import FirebaseAuth
import Foundation

class ProfileViewViewModel: ObservableObject {
    
    func logout() {
        do {
            try FirebaseManager.shared.auth.signOut()
        } catch {
            print(error)
        }
        
    }
}
