//
//  O_N_ChatApp.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//

import SwiftUI

@main
struct O_N_ChatApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var appState = AppState()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
                .environmentObject(appState)

        }
    }
}
