//
//  CustomButton.swift
//  ChatApp
//
//  Created by Hamada Salhab on 06.02.2024.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(backgroundColor)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: 22))
            }
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Button", backgroundColor: .blue) {
            
        }
    }
}
