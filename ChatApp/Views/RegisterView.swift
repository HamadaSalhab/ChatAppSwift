//
//  RegisterView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Form {
            ScrollView {
                
                Button {
                    viewModel.showImagePicker = true
                } label: {
                    if viewModel.profilePicture.pngData() == nil {
                        Image(systemName: "person.circle")
                            .font(.system(size: 100))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                    } else {
                        Image(uiImage: viewModel.profilePicture)
                            .resizable()
                            .cornerRadius(50)
                            .frame(width: 100, height: 100)
                            .background(Color.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .sheet(isPresented: $viewModel.showImagePicker) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.profilePicture)
                }
                
                TextField("Full Name", text: $viewModel.fullName)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .padding()
                
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()
                
                CustomButton(title: "Create Account", backgroundColor: .blue) {
                    viewModel.register()
                }
                .frame(minHeight: 40, maxHeight: 50)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
