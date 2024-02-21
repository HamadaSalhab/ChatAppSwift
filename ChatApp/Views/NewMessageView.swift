//
//  NewMessageView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 07.02.2024.
//

import SwiftUI

struct NewMessageView: View {
    @ObservedObject var viewModel: NewMessageViewViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(){
        viewModel = NewMessageViewViewModel()
    }
    
//    @State var switchToConversationView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
//                    .frame(height: 1.5)
//                    .overlay(.blue)
//                    .shadow(radius: 5)
                ForEach (viewModel.users) { otherUser in
                    NavigationLink(destination: ConversationView(otherUserID: otherUser.id)) {
//                        presentationMode.wrappedValue.dismiss()
                        userChatCard(user: otherUser)
                    }
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func userChatCard(user: User) -> some View {
        VStack {
            HStack(spacing: 16) {
                UserProfilePic(
                    url: user.profilePicURL,
                    width: 70,
                   height: 70
                )
                Spacer()
                Text(user.fullName)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundStyle(Color(.label))
            }
            .padding()
            Divider()

        }
    }
}

//#Preview {
//    NewMessageView(currentUser: User(id: "YDHafVIqc2gZlVzyOKIlekO68UD3", fullName: "Hamada Salhab", email: "hamada.a.salhab@gmail.com", profilePicURL: "https://firebasestorage.googleapis.com:443/v0/b/swiftchatapp-c5130.appspot.com/o/profile-pictures%2FYDHafVIqc2gZlVzyOKIlekO68UD3.jpeg?alt=media&token=f3d98876-260c-4b01-9109-366f23c28938"))
//}
