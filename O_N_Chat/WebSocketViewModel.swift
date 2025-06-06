//
//  WebSocketViewModel.swift
//  O_N_Chat
//
//  Created by Nnamani Christian on 30/05/2025.
//

import SwiftUI
import Foundation

class WebSocketManager : ObservableObject {
    


    
    @Published var receivedMessages: [String] = []
    @Published var isConnected: Bool = false
    @Published var connectionStatus: String = "Disconnected"
    
    
     var coreDataViewModel : CoreDataViewModel

    private var webSocketTask: URLSessionWebSocketTask?
    private let url: URL

    init(url: URL , coreDataViewModel : CoreDataViewModel) {
        self.url = url
        self.coreDataViewModel = coreDataViewModel
    }

    func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()

        self.isConnected = true
        self.connectionStatus = "Connecting..."
        receiveMessage()
        ping()
        sendMessage( "")
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        self.isConnected = false
        self.connectionStatus = "Disconnected"
        self.webSocketTask = nil
    }

    func sendMessageChat(message : Message) {
        guard let webSocketTask = webSocketTask else {
            print("WebSocket task is not active.")
            return
        }
        
        do{
            let encodeMessage = try JSONEncoder().encode(message)
            if let messageString = String(data: encodeMessage, encoding: .utf8){
                webSocketTask.send(.string(messageString)) { error in
                    if let error = error {
                        print("Error sending message: \(error)")
                    } else {
                        print("Message sent: \(message)")
                    }
                }
            }
        }catch{
            
        }
        
        
       
    }
    
    func sendMessage(_ message: String) {
        guard let webSocketTask = webSocketTask else {
            print("WebSocket not connected")
            return
        }
        
        guard let username = UserDefaults.standard.string(forKey: "username")else{
            return
        }



        let connectMessage = WebSocketMessageConnect(
            type: "connect",
            userId: username
        )
        

        do {
            let jsonData = try JSONEncoder().encode(connectMessage)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask.send(.string(jsonString)) { error in
                    if let error = error {
                        print("Error sending message: \(error)")
                    } else {
                        print("Message sent successfully: \(jsonString)")
                    }
                }
            } else {
                print("Could not convert JSON Data to String")
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
                self?.isConnected = false
                self?.connectionStatus = "Disconnected (Error)"
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                    do{                        
                        let jsonString = text.data(using: .utf8)
                        var decodedMessage = try JSONDecoder().decode(Message.self, from: jsonString!)
                        decodedMessage.isCurrentUser = false
                        self?.coreDataViewModel.checkIfExist(contact: Contact(name: decodedMessage.from, avatarColor: .blue))
                        self?.coreDataViewModel.insertMessage(message: decodedMessage)
                        
                        print("Gotten \(decodedMessage)")
                            
                        print(decodedMessage)
                            self?.receivedMessages.append("Received: \(text)")
                            self?.connectionStatus = "Connected"
                        
                    }catch{
                        print(error)
                    }
                    }
                case .data(let data):
                    DispatchQueue.main.async {
                        self?.receivedMessages.append("Received Data: \(data.count) bytes")
                        self?.connectionStatus = "Connected"
                    }
                @unknown default:
                    fatalError("Unknown message type")
                }
                self?.receiveMessage()
            }
        }
    }

    private func ping() {
        webSocketTask?.sendPing { error in
            if let error = error {
                print("Ping failed: \(error)")
            } else {
                print("Ping successful")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.ping()
            }
        }
    }
}
