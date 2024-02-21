//
//  ConversationView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 08.02.2024.
//

import SwiftUI

struct ConversationView: View {
    @StateObject var viewModel = ConversationViewViewModel()
    let otherUserID: String

    init(otherUserID: String) {
        self.otherUserID = otherUserID
    }

    var body: some View {
        VStack {
            messagesView
            bottomBarView
        }
        .navigationBarTitle(Text(viewModel.otherUser?.fullName ?? "Loading..."), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let profilePicURL = viewModel.otherUser?.profilePicURL {
                    UserProfilePic(
                        url: profilePicURL,
                        width: 40,
                        height: 40
                    )
                    .padding(.vertical, 5)
                } else {
                   
                }
            }
        }
        .onAppear {
            Task {
                // Asynchronously load and set up the viewModel
                await viewModel.asyncSetup(otherUserID: self.otherUserID)
            }
        }
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(viewModel.chatMessages) { message in
                            MessageCard(sent: message.sent, text: message.text)
                        }
                        HStack { Spacer() }.id("Bottom")
                    }
                    .onReceive(viewModel.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo("Bottom", anchor: .bottom)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var bottomBarView: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("New message...", text: $viewModel.messageText)
            Button {
                Task {
                    await viewModel.sendMessage()
                }
            } label: {
                Text("Send")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

//#Preview {
//    ConversationView(currentUser: User(fromDictionary: ["id" : "Any", "fullName" : "No one"]), otherUser: User(fromDictionary: ["id" : "Any", "fullName" : "No one"]))
//}
