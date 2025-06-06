//
//  EnterPersonToChat.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 03/06/2025.
//

import SwiftUI

struct EnterPersonToChat: View {
    @State var personToChat : String = ""
    @StateObject private var viewModel: CoreDataViewModel
      @StateObject private var webSocketManager: WebSocketManager

      init() {
          let viewModel = CoreDataViewModel(viewContext: PersistenceController.shared.container.viewContext)
          _viewModel = StateObject(wrappedValue: viewModel)
          
          let webSocket = WebSocketManager(url: URL(string: "ws://172.20.10.2:8080")!, coreDataViewModel: viewModel)
          _webSocketManager = StateObject(wrappedValue: webSocket)
      }
    
    
    
    var body: some View {
        VStack{
            // MARK: - Search Bar
            TextField("Search contacts...", text: $personToChat)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            
            
            Spacer()
            
            NavigationLink(destination: ChatView(viewModel :viewModel , webSocketViewModel:webSocketManager ,personToChat: personToChat , participant1: "" , participant2: "") , label: {
                if personToChat.isEmpty {
                    
                }else{
                    Text("Chat \(personToChat)")
                    .padding(.leading , 20)
                    .padding(.top , 10)
                    .padding(.bottom , 10)
                    .padding(.trailing , 20)
                    .background(Color.blue.opacity(0.5))
                    .foregroundStyle(.white)
                    .cornerRadius(7)
                }
            })

        }
    }
}

#Preview {
    NavigationView{
        EnterPersonToChat()

    }
}
