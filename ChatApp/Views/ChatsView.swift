//
//  ChatsView.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import SwiftUI

struct ChatsView: View {
    @ObservedObject var viewModel = ChatsViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // custom nav bar
                customNavbar
                if viewModel.recentMessages.isEmpty {
                    Spacer()
                    Text("You have no recent messages. Start a chat now!")
                    Spacer()
                } else {
                    recentMessagesView
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    var customNavbar: some View {
        VStack {
            HStack(spacing: 16) {
                if let profilePicURL = viewModel.user?.profilePicURL {
                    UserProfilePic(
                        url: profilePicURL,
                        width: 70,
                       height: 70
                    )
                }
                else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 34, weight: .heavy))
                        .frame(width: 70, height: 70)
                }
                            
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.user?.fullName ?? "Loading...")
                        .font(.system(size: 24, weight: .bold))
                    
                    HStack {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 14, height: 14)
                        Text("online")
                            .font(.system(size: 12)).foregroundColor(Color(.lightGray))
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "gear")
                }
                
            }
            .padding()
            
            LinearGradient(colors: [.white, Color(.sRGB, white: 0.85, opacity: 1)], startPoint: .bottom, endPoint: .top)
                   .frame(height: 3)
                   .opacity(0.8)
        }
    }
    
    @ViewBuilder
    var recentMessagesView: some View {
        ScrollView {
            ForEach(viewModel.recentMessages) { recentMessage in
                recentChatCard(recentMessage: recentMessage)
            }.padding(.bottom, 50)
        }
    }
    
    @ViewBuilder
    func recentChatCard(recentMessage: RecentMessage) -> some View {
        NavigationLink(destination: ConversationView(otherUserID: recentMessage.received ? recentMessage.fromID : recentMessage.toID)) {
            VStack {
                HStack(spacing: 16) {
                    UserProfilePic(url: recentMessage.profilePicURL,  width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 7) {
                        Text(recentMessage.fullName)
                            .font(.system(size: 16, weight: .bold))
                        Text("\(recentMessage.sent ? "You: " : "")\(recentMessage.text)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }
                    Spacer()
                    
                    Text(recentMessage.timeAgo)
                        .font(.system(size: 14, weight: .semibold))
                }
                Divider()
                    .padding(.vertical, 8)
            }.padding(.horizontal)

        }
        
    }
    
    @State var showNewMessageView = false
    
    @ViewBuilder
    var newMessageButton: some View {
        Button {
            showNewMessageView.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }.padding(.vertical, 6)
        .fullScreenCover(isPresented: $showNewMessageView) {
            NewMessageView()
        }
    }
}

#Preview {
    ChatsView(viewModel: ChatsViewViewModel())
}
