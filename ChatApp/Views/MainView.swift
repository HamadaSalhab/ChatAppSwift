//
//  ContentView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import SwiftUI

enum AuthMethod: String, Equatable, CaseIterable {
    case login = "Login"
    case register = "Register"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }

}

struct MainView: View {
    @State var authMethod: AuthMethod = .register
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            homeView
            
        } else {
            authenticationView
        }
    }
    
    @ViewBuilder
    var homeView: some View {
        TabView{
            ChatsView()
            .tabItem{
                Label("Chats", systemImage: "message.fill")
            }
            
            ProfileView()
            .tabItem{
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
    
    
    @ViewBuilder
    var authenticationView: some View {
        NavigationView {
            VStack {
                Picker(selection: $authMethod, label: Text("Login/Register picker")) {
                    ForEach(AuthMethod.allCases, id: \.self) { value in
                        Text(value.localizedName)
                            .tag(value)
                    }
                }
                .pickerStyle(.segmented)
                
                if authMethod == .login {
                    LoginView()
                } else {
                    RegisterView()
                }
                
            }
            .padding()
            .navigationTitle(authMethod == .login ? "Login" : "Create Account")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
