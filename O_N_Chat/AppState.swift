//
//  AppState.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 03/06/2025.
//

import SwiftUI

class AppState: ObservableObject {

    @Published var loggedIn = false
    
    init() {
        if UserDefaults.standard.string(forKey: "username") != nil {
            loggedIn = true
        }
    }
    
    
    
}
