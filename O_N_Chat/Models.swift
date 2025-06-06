//
//  Models.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//
import SwiftUI


struct Message: Identifiable , Codable{
    var id = UUID()
    let content: String
    var isCurrentUser: Bool
    let from : String
    let time : String
    let to : String
}


struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let avatarColor: Color 
}


struct WebSocketMessageConnect: Encodable {
    let type: String
    let userId: String
}


func getFullDateTimeString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm:ss a"
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(from: Date())
}
