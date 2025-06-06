//
//  MessageBubble.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//

import SwiftUI

struct MessageBubble: View {
    
    let message: Message

    var body: some View {
        
        HStack {
            if message.isCurrentUser {
                Spacer()
            }
            Text(message.content)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(message.isCurrentUser ?
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing) :
                            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.2)]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(message.isCurrentUser ? .white : .primary)
                .cornerRadius(15)
            if !message.isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal, message.isCurrentUser ? 50 : 0)
        .padding(.leading, message.isCurrentUser ? 0 : 50)
    }
}

