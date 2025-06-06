//
//  PickAUsername.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 03/06/2025.
//

import SwiftUI

struct PickAUsername: View {
    
    @EnvironmentObject var appState : AppState
       @State private var isSaveVerified = false
       @State private var showError = false
    @State var usernamePicked = ""
    
    @StateObject private var webSocketManager: WebSocketManager
    @StateObject private var viewModel: CoreDataViewModel


    init() {
        let viewModel = CoreDataViewModel(viewContext: PersistenceController.shared.container.viewContext)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let webSocket = WebSocketManager(url: URL(string: "ws://172.20.10.2:8080")!, coreDataViewModel: viewModel)
        _webSocketManager = StateObject(wrappedValue: webSocket)
    }
    
     var body: some View {
             VStack {
                 Text("Welcome to O N Chat")
                     .font(.system(size: 31, weight: .bold))
                     .frame(maxWidth: .infinity, alignment: .leading)
                 
                 Text("Pick a username")
                     .font(.system(size: 40, weight: .bold))
                     .frame(maxWidth: .infinity, alignment: .leading)
                 
                 TextField("Pick a username", text: $usernamePicked)
                     .padding(.vertical, 12)
                     .padding(.horizontal, 20)
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(10)
                     .padding(.horizontal)
                     .padding(.top, 10)
                     .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                 
                 Spacer()
                 
                 Button("Select") {
                     if !usernamePicked.isEmpty {
                         saveAndNavigate()
                     }
                 }
                 .padding()
                 .background(Color.blue.opacity(0.5))
                 .foregroundStyle(.white)
                 .cornerRadius(7)
             }
             .padding()

     }
    

    func saveAndNavigate(){
        UserDefaults.standard.set(usernamePicked, forKey: "username")
        
        if let getUserName = UserDefaults.standard.string(forKey: "username") , getUserName == usernamePicked {
            print("Username saved")
            webSocketManager.connect()
            appState.loggedIn = true
        }else{
            
        }
            
        
    }
}

