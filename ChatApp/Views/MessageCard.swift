//
//  MessageCard.swift
//  ChatApp
//
//  Created by Hamada Salhab on 11.02.2024.
//

import SwiftUI

struct MessageCard: View {
    let sent: Bool
    let text: String
    
    var body: some View {
        if sent {
            HStack {
                Spacer()
                HStack{
                    Text(text)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(25)
            }
            .padding(.horizontal)
        } else {
            HStack {
                HStack{
                    Text(text)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                .cornerRadius(25)
            Spacer()
            }
            .padding(.horizontal)

        }    }
}

#Preview {
    MessageCard(sent: true, text: "Hello")
}
