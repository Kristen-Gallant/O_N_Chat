//
//  ContentView.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @StateObject private var viewModel: CoreDataViewModel
    @StateObject private var webSocketManager: WebSocketManager
      init() {
          let viewModel = CoreDataViewModel(viewContext: PersistenceController.shared.container.viewContext)
          _viewModel = StateObject(wrappedValue: viewModel)
          let webSocket = WebSocketManager(url: URL(string: "ws://172.20.10.2:8080")!, coreDataViewModel: viewModel)
          _webSocketManager = StateObject(wrappedValue: webSocket)
      }
    @EnvironmentObject var appstate : AppState
    @State private var messageToSend: String = ""
    var body: some View {
        NavigationView {
           if appstate.loggedIn {
                ScrollView(.vertical){
                    VStack{
                        
                            ContactListView(viewModel: viewModel , webSocketViewModel: webSocketManager)
                        
                    }
                    
                }
            }else{
                PickAUsername()
                
            }
            
        }
        .onAppear{
            webSocketManager.connect()
        }
       
    
    }
    
}
    

#Preview {
        ContentView()
            .environmentObject(AppState())
}
