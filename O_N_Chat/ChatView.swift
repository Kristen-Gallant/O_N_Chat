//
//  ChatView.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//

import SwiftUI
import CoreData

struct ChatView: View {
     @State private var newMessageText: String = ""
     @ObservedObject var viewModel : CoreDataViewModel
     @ObservedObject var webSocketViewModel : WebSocketManager
     var personToChat : String
     let participant1: String
     let participant2: String

     @Environment(\.managedObjectContext) private var viewContext

     @FetchRequest var messages: FetchedResults<MessageEntity>

    init(viewModel : CoreDataViewModel , webSocketViewModel : WebSocketManager,personToChat : String ,participant1: String, participant2: String) {
            self.viewModel = viewModel
            self.webSocketViewModel = webSocketViewModel
            self.personToChat = personToChat
            self.participant1 = participant1
            self.participant2 = participant2

           let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()

           let forwardPredicate = NSPredicate(format: "from == %@ AND to == %@", participant1, participant2)
           let reversePredicate = NSPredicate(format: "from == %@ AND to == %@", participant2, participant1)

           fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
               forwardPredicate,
               reversePredicate
           ])
           
           fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \MessageEntity.timestamp, ascending: true)]

           _messages = FetchRequest(fetchRequest: fetchRequest)
       }
    
    

    var body: some View {
        VStack {
            Text(personToChat)
                .padding(.vertical , 5)
                .font(.system(size: 20).bold())
            
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubble(message: Message(content: message.content!, isCurrentUser: message.isCurrentUser, from: message.from!, time: message.time!, to: message.to!))
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .onChange(of: messages.count) {
                    if let lastMessageId = messages.last?.id {
                        scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
            }

            Spacer()

            HStack {
                TextField("Type your message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                Button(action: addMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Circle())
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .padding(.trailing)
            }
            .padding(.bottom, 10)
            .background(Color.gray.opacity(0.05).ignoresSafeArea(.keyboard, edges: .bottom))
        }
    
     
       
    }
    
    func insertMessage(message : Message){
        let insertMessage = MessageEntity(context: viewContext)
        insertMessage.id = UUID()
        insertMessage.time = message.time
        insertMessage.from = message.from
        insertMessage.to = message.to
        insertMessage.isCurrentUser = message.isCurrentUser
        insertMessage.content = message.content
        insertMessage.timestamp = Date()
        
        do{
           try viewContext.save()
        }catch{
            
            print("Failed to save task: \(error)")
        }
    }
    

    
    func checkIfExist(contact : Contact) {
        let fetchRequest: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", contact.name)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            
            if results.isEmpty {
              
                let insertUser = PersonEntity(context: viewContext)
                insertUser.id = UUID()
                insertUser.name = contact.name
                insertUser.avatarColor = ""
                
                try viewContext.save()
            } else {
               
            }
        } catch {
            print("Error checking/inserting Bob: \(error.localizedDescription)")
        }
    }

    
    

    
    func addMessage(){
        let username = UserDefaults.standard.string(forKey: "username")
        let message =  Message(content: newMessageText , isCurrentUser: true, from: username!, time: getFullDateTimeString(), to: personToChat)
        webSocketViewModel.connect()
        checkIfExist(contact: Contact(name: personToChat, avatarColor: .black))
        insertMessage(message: message)
        webSocketViewModel.sendMessageChat(message: message)
        newMessageText = ""

    }
}

