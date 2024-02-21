//
//  ProfileView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        VStack {
            Text("This is the profile view")
            Text("You should see some information about the user")
            Spacer()
            Button {
                viewModel.logout()
            } label: {
                Text("Logout")
                    .foregroundColor(.red)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
