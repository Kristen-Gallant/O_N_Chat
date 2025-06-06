//
//  PersonView.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//

import SwiftUI
import CoreData


struct ContactListView: View {
    @EnvironmentObject var appState : AppState
    
    @ObservedObject var viewModel: CoreDataViewModel
    
    @ObservedObject var webSocketViewModel : WebSocketManager
    
    var username = UserDefaults.standard.string(forKey: "username")
    
    @Environment(\.managedObjectContext) private var viewContext

      @FetchRequest(
          sortDescriptors: [NSSortDescriptor(keyPath: \PersonEntity.id, ascending: true)],
          animation: .default)
      private var people: FetchedResults<PersonEntity>
    
   
    
    
    let colours  : [Color] = [.blue , .red , .pink , .green , .purple ]

    @State private var searchText: String = ""
    
    @State private var personToChat: String = ""

    @State private var contacts: [Contact] = [
        Contact(name: "Alice Johnson", avatarColor: .blue),
        Contact(name: "Bob Williams", avatarColor: .green),
        Contact(name: "Charlie Brown", avatarColor: .orange),
        Contact(name: "Diana Miller", avatarColor: .red),
        Contact(name: "Eve Davis", avatarColor: .purple),
        Contact(name: "Frank White", avatarColor: .teal),
        Contact(name: "Grace Taylor", avatarColor: .pink),
        Contact(name: "Henry Clark", avatarColor: .indigo),
        Contact(name: "Ivy Lewis", avatarColor: .yellow),
        Contact(name: "Jack Hall", avatarColor: .cyan)
    ]

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
       
            
            VStack {
                TextField("Search contacts...", text: $searchText)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                ForEach(people) { contact in
                    NavigationLink(destination: ChatView(viewModel : viewModel , webSocketViewModel: webSocketViewModel ,personToChat: contact.name! , participant1: contact.name! , participant2: username!), label: {
                            
                        ContactRow(contact: Contact(name: contact.name!, avatarColor: colours.randomElement()!))
                        })
                        .buttonStyle(.plain)
                           
                          
                    }
                
               
            }
        
            .background(Color.white.ignoresSafeArea())
        
            .toolbar{
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: {
                        EnterPersonToChat()
                    }, label: {
                      Image(systemName: "plus.circle")
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                })
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Image(systemName: "arrowshape.right.fill")
                        .onTapGesture {
                            clearAllUserDefaults()
                        }

                })
                
                
                
                
                
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                     
                    }) {
                        if let username = UserDefaults.standard.string(forKey: "username"){
                            Text("Hello, \(username) 👋🏽")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 26).bold())
                        }
                      
                    }
                })
            }
        
        .padding()
    }
    
    
    func clearAllUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
            appState.loggedIn = false
        }
    }
    
    
    
}


