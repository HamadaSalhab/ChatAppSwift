//
//  UserProfilePic.swift
//  ChatApp
//
//  Created by Hamada Salhab on 08.02.2024.
//

import SwiftUI

struct UserProfilePic: View {
    @State var url = ""
    @State var width = 70.0
    @State var height = 70.0
    
    var body: some View {
        AsyncImage(
            url: URL(string: url),
            content: { image in
                image
                    .resizable()
                    .cornerRadius(50)
                    .frame(width: width, height: height)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label)))
                    .shadow(color: Color(.label), radius: 1)
                
            },
            placeholder: {
                ProgressView()
                    .frame(width: 70, height: 70)
            }
        )

    }
}

#Preview {
    UserProfilePic()
}
