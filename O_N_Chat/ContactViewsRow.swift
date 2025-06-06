//
//  ContactViewsRow.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 06/06/2025.
//

import SwiftUI
import CoreData

struct ContactRow: View {
    let contact: Contact

    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(contact.avatarColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(contact.name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.white)
                )
            Text(contact.name)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
