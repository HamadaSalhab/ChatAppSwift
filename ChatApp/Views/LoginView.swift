//
//  LoginView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        Form {
            ScrollView{
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()

                CustomButton(title: "Login", backgroundColor: .blue) {
                    viewModel.login()
                }
                .frame(minHeight: 40, maxHeight: 50)
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
