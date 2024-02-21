//
//  MainViewViewModel.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import FirebaseAuth
import Foundation

class MainViewViewModel: ObservableObject {
    @Published var currentUserID: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = FirebaseManager.shared.auth.addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserID = user?.uid ?? ""
            }
        }
    }
    
    public var isAuthenticated: Bool {
        return FirebaseManager.shared.auth.currentUser != nil
    }

}
