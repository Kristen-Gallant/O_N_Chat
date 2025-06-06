//
//  CoreDataViewModel.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 29/05/2025.
//
import SwiftUI
import CoreData
import Combine



class CoreDataViewModel : ObservableObject {
    
    @Published var messages: [MessageEntity] = []
    


    
    @Published var persons: [PersonEntity] = []
    
    let viewContext : NSManagedObjectContext

    
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        print("List of people \(fetchPeople())")

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
            print("message Saved successfully")
        }catch{
            print("Failed to save task: \(error)")
        }
    }
    
    
    func fetchPeople() -> [PersonEntity] {
        let fetchRequest: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        
        do {
            let people = try viewContext.fetch(fetchRequest)
            persons = people
            return people
        } catch {
            print("Failed to fetch PersonEntity: \(error.localizedDescription)")
            return []
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

    
    
    func fetchMessages(from: String, to: String) {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        
        let forwardPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "from == %@", from),
            NSPredicate(format: "to == %@", to)
        ])
        
        let reversePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "from == %@", to),
            NSPredicate(format: "to == %@", from)
        ])
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            forwardPredicate,
            reversePredicate
        ])
        
        do {
            let messagesFetched = try viewContext.fetch(fetchRequest)
            messages = messagesFetched
           
        } catch {
            print("Failed to fetch messages: \(error.localizedDescription)")
        }
    }
    
}
